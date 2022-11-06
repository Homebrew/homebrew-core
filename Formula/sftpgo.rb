class Sftpgo < Formula
  desc "Fully featured SFTP server with optional HTTP/S, FTP/S and WebDAV support"
  homepage "https://github.com/drakkan/sftpgo"
  url "https://github.com/drakkan/sftpgo/releases/download/v2.4.2/sftpgo_v2.4.2_src_with_deps.tar.xz"
  sha256 "363e087599654385a6f8a4ffcf42b458301bc0c74b8aa35e13cc886b19948d19"
  license "AGPL-3.0-only"

  bottle do
    sha256 arm64_ventura:  "14fc18cbbfb2caf6cc91129657fbd4d345d2d430c40dd3f640c2c3f23ca01d69"
    sha256 arm64_monterey: "5c2afa12b2e2a4b5571e92b99f99261f1192d9dc2d5291b38beac1abacccbdf5"
    sha256 arm64_big_sur:  "0516d81cff9f16b15ef9ecd18bd3b1f8a72cf362966e33eb67af696bec29d0f9"
    sha256 ventura:        "4923cc09c2ad86013b6112b412243c73451a9aa106f8cb038d0080ef0de3d204"
    sha256 monterey:       "27ee3b4d9ae84cc7af7cff96f17d093879d62332dc8bc0dbad36461d75649ed1"
    sha256 big_sur:        "ea92b96cd0ce50dfb3cc30a511bf20c6837ee515a603e40b811ae6e765428f4d"
    sha256 catalina:       "b2a048ad4c292bf28d7a67a65d9ec13436f4c4944ff53f5ab4c4dc3fd7921182"
    sha256 x86_64_linux:   "d1c900cbf7c8e1ae72414203b22983e036c1e7575b8a9fed9c2794ac3da0fabb"
  end

  depends_on "go" => :build

  def install
    git_sha = (buildpath/"VERSION.txt").read.lines.second.strip
    ldflags = %W[
      -s -w
      -X github.com/drakkan/sftpgo/v2/internal/util.additionalSharedDataSearchPath=#{opt_pkgshare}
      -X github.com/drakkan/sftpgo/v2/internal/version.commit=#{git_sha}
      -X github.com/drakkan/sftpgo/v2/internal/version.date=#{time.iso8601}
    ].join(" ")
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "nopgxregisterdefaulttypes"
    system bin/"sftpgo", "gen", "man", "-d", man1

    generate_completions_from_executable(bin/"sftpgo", "gen", "completion")

    inreplace "sftpgo.json" do |s|
      s.gsub! "\"users_base_dir\": \"\"", "\"users_base_dir\": \"#{var}/sftpgo/data\""
    end

    pkgetc.install "sftpgo.json"
    pkgshare.install "static", "templates", "openapi"
    (var/"sftpgo").mkpath
    (var/"sftpgo/env.d").mkpath
  end

  def caveats
    <<~EOS
      Default data location:

      #{var}/sftpgo

      Configuration file location:

      #{pkgetc}/sftpgo.json
    EOS
  end

  service do
    run [bin/"sftpgo", "serve", "--config-file", etc/"sftpgo/sftpgo.json", "--log-file-path",
         var/"sftpgo/log/sftpgo.log"]
    keep_alive true
    require_root true
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
