class Sftpgo < Formula
  desc "Fully featured SFTP server with optional HTTP/S, FTP/S and WebDAV support"
  homepage "https://github.com/drakkan/sftpgo"
  url "https://github.com/drakkan/sftpgo/releases/download/v2.4.4/sftpgo_v2.4.4_src_with_deps.tar.xz"
  sha256 "9e248dea64e5738ddcb9b10ed47645887665c8adfe0d5554052fb31088fce665"
  license "AGPL-3.0-only"

  bottle do
    sha256 arm64_ventura:  "6898c4baf4c867d16ff36744bcbf75c73293b242a53c6ddb7f1f8db9497167aa"
    sha256 arm64_monterey: "2d60280325a64059ff1fd1142a8a95e53a312e7673f65400549c5fd96be58f50"
    sha256 arm64_big_sur:  "f47a01e057a0129135d3f7f1161cba3da29cbd11d2c71cffc3d29a90ba1ceaeb"
    sha256 ventura:        "002729711b5c4680b32ddc64f6ce51285bba4bc283ecf053b46521c261b08d03"
    sha256 monterey:       "2d48a02728ce09981ba3f92a1dd2042d2585ad2a28d97788439e7977f6615d3c"
    sha256 big_sur:        "e69584ececa2d551378ff57a1bd688690a807dfe3a5efb4741d7c659f3e098c9"
    sha256 x86_64_linux:   "9d7f992e82f099fbfb9dac82d2df66c342cfa2cde105f2672c124184745d770a"
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
