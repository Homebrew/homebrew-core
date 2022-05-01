class Sftpgo < Formula
  desc "Fully featured SFTP server with optional HTTP/S, FTP/S and WebDAV support"
  homepage "https://github.com/drakkan/sftpgo"
  url "https://github.com/drakkan/sftpgo/releases/download/v2.2.3/sftpgo_v2.2.3_src_with_deps.tar.xz"
  sha256 "6c8676725e86ee3f6ad46a340a84f0da37cab8b6ea7b6aee86b2b96ba5e6671a"
  license "AGPL-3.0-only"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-o", "sftpgo"
    inreplace "sftpgo.json" do |s|
      s.gsub! "\"users_base_dir\": \"\"", "\"users_base_dir\": \"#{var}/sftpgo/data\""
      s.gsub! "\"backups_path\": \"backups\"", "\"backups_path\": \"#{var}/sftpgo/backups\""
      s.gsub! "\"credentials_path\": \"credentials\"", "\"credentials_path\": \"#{var}/sftpgo/credentials\""
      s.gsub! "\"templates_path\": \"templates\"", "\"templates_path\": \"#{opt_pkgshare}/templates\""
      s.gsub! "\"static_files_path\": \"static\"", "\"static_files_path\": \"#{opt_pkgshare}/static\""
      s.gsub! "\"openapi_path\": \"openapi\"", "\"openapi_path\": \"#{opt_pkgshare}/openapi\""
    end
    bin.install "sftpgo"
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

      If the SFTPGo service does not start, make sure that TCP ports 2022 and 8080 are not used by other services
      or change the SFTPGo configuration to suit your needs.
    EOS
  end

  plist_options startup: true
  service do
    run [opt_bin/"sftpgo", "serve", "--config-file", etc/"sftpgo/sftpgo.json", "--log-file-path",
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
    ENV["SFTPGO_SFTPD__BINDINGS__0__ADDRESS"] = "127.0.0.1"
    ENV["SFTPGO_SFTPD__BINDINGS__0__PORT"] = sftp_port.to_s
    ENV["SFTPGO_LOG_FILE_PATH"] = "#{testpath}/sftpgo.log"
    pid = fork do
      exec bin/"sftpgo", "serve", "--config-file", "#{pkgetc}/sftpgo.json"
    end

    sleep 10
    assert_match expected_output, shell_output("curl -s 127.0.0.1:#{http_port}/healthz")
    shell_output("ssh-keyscan -p #{sftp_port} 127.0.0.1")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
  end
end
