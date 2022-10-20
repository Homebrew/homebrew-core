class Sftpgo < Formula
  desc "Fully featured SFTP server with optional HTTP/S, FTP/S and WebDAV support"
  homepage "https://github.com/drakkan/sftpgo"
  url "https://github.com/drakkan/sftpgo/releases/download/v2.3.6/sftpgo_v2.3.6_src_with_deps.tar.xz"
  sha256 "dd1e3df81e808b090fb9d77e2cdf4f0a108d53646b69c201cd710c38522079a5"
  license "AGPL-3.0-only"

  bottle do
    sha256 arm64_monterey: "2dc6c002dca5285b082e2087251f3675a684820df36ae9309c72829b498d510a"
    sha256 arm64_big_sur:  "01089e3962ea05fd48eaea6cb4e434cef9f5a537e02be3ba9262ced218de15b5"
    sha256 monterey:       "8083269be878b214edb991cb4500836d919cc57872d49299506d61322884ff33"
    sha256 big_sur:        "65b6e77399e75378449aee0f396043b40c8c46343c4d269e2a64d7443dcd6933"
    sha256 catalina:       "34390caca6f71b078f6eb44be565288d498a2a28f48a5dcf7566046780c4ff32"
    sha256 x86_64_linux:   "d0c6b0c27a5e8e0832f0e0ba781ba5990e5b48ec808f5496fdcf40fe9b053bde"
  end

  depends_on "go" => :build

  def install
    git_sha = (buildpath/"VERSION.txt").read.lines.second.strip
    ldflags = %W[
      -s -w
      -X github.com/drakkan/sftpgo/v2/util.additionalSharedDataSearchPath=#{opt_pkgshare}
      -X github.com/drakkan/sftpgo/v2/version.commit=#{git_sha}
      -X github.com/drakkan/sftpgo/v2/version.date=#{time.iso8601}
    ].join(" ")
    system "go", "build", *std_go_args(ldflags: ldflags)
    system bin/"sftpgo", "gen", "man", "-d", man1

    generate_completions_from_executable(bin/"sftpgo", "gen", "completion")

    inreplace "sftpgo.json" do |s|
      s.gsub! "\"users_base_dir\": \"\"", "\"users_base_dir\": \"#{var}/sftpgo/data\""
    end

    pkgetc.install "sftpgo.json"
    pkgshare.install "static", "templates", "openapi"
    (var/"sftpgo").mkpath
  end

  def caveats
    <<~EOS
      Default data location:

      #{var}/sftpgo

      Configuration file location:

      #{pkgetc}/sftpgo.json
    EOS
  end

  plist_options startup: true
  service do
    run [bin/"sftpgo", "serve", "--config-file", etc/"sftpgo/sftpgo.json", "--log-file-path",
         var/"sftpgo/log/sftpgo.log"]
    keep_alive true
    working_dir var/"sftpgo"
  end

  test do
    expected_output = "ok"
    http_port = free_port
    sftp_port = free_port
    ENV["SFTPGO_HTTPD__BINDINGS__0__PORT"] = http_port.to_s
    ENV["SFTPGO_HTTPD__BINDINGS__0__ADDRESS"] = "127.0.0.1"
    ENV["SFTPGO_SFTPD__BINDINGS__0__PORT"] = sftp_port.to_s
    ENV["SFTPGO_SFTPD__BINDINGS__0__ADDRESS"] = "127.0.0.1"
    ENV["SFTPGO_SFTPD__HOST_KEYS"] = "#{testpath}/id_ecdsa,#{testpath}/id_ed25519"
    ENV["SFTPGO_LOG_FILE_PATH"] = ""
    pid = fork do
      exec bin/"sftpgo", "serve", "--config-file", "#{pkgetc}/sftpgo.json"
    end

    sleep 5
    assert_match expected_output, shell_output("curl -s 127.0.0.1:#{http_port}/healthz")
    system "ssh-keyscan", "-p", sftp_port.to_s, "127.0.0.1"
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
  end
end
