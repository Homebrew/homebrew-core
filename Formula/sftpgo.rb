class Sftpgo < Formula
  desc "Fully featured SFTP server with optional HTTP/S, FTP/S and WebDAV support"
  homepage "https://github.com/drakkan/sftpgo"
  url "https://github.com/drakkan/sftpgo/releases/download/v2.4.5/sftpgo_v2.4.5_src_with_deps.tar.xz"
  sha256 "30cc3d3c7dffd9fb760d66e0d9bb030fab61b76a59d2d63f9c383674042eddef"
  license "AGPL-3.0-only"

  bottle do
    sha256 arm64_ventura:  "fba44752221e15d23273a47e32c6535cbb9e8318e45a04a58250dcd7e10864f8"
    sha256 arm64_monterey: "89cb550b1236e2fbe8878b69bdda148ced9c297762c6d548506f52ad37174dce"
    sha256 arm64_big_sur:  "f08c1ac90298976b81d8897a3eb1b13106779e9753100c9c87fbe666ffcf6212"
    sha256 ventura:        "90f36725ca572ac71f14127f87855453321224dacef0cd935acf58369d226ac9"
    sha256 monterey:       "e9759e53c23153c1e5c528843e57927cb15f5f57c01f2ac73bec9277ef5f64d7"
    sha256 big_sur:        "94eea8e85c3f9cef11a58fe10dc7cfce20694f626c3a156e00de973eb8fcd107"
    sha256 x86_64_linux:   "17b942956eef66b48cbf758484ac492607ffdf338eefa567703f500efb0941bf"
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
    run [opt_bin/"sftpgo", "serve", "--config-file", etc/"sftpgo/sftpgo.json", "--log-file-path",
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
