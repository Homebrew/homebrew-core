class Sftpgo < Formula
  desc "Fully featured SFTP server with optional HTTP/S, FTP/S and WebDAV support"
  homepage "https://github.com/drakkan/sftpgo"
  url "https://github.com/drakkan/sftpgo/releases/download/v2.2.3/sftpgo_v2.2.3_src_with_deps.tar.xz"
  sha256 "6c8676725e86ee3f6ad46a340a84f0da37cab8b6ea7b6aee86b2b96ba5e6671a"
  license "AGPL-3.0-only"

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", "sftpgo"
    inreplace "sftpgo.json" do |s|
      s.gsub! "\"users_base_dir\": \"\"", "\"users_base_dir\": \"#{var}/sftpgo/data\""
      s.gsub! "\"backups_path\": \"backups\"", "\"backups_path\": \"#{var}/sftpgo/backups\""
      s.gsub! "\"credentials_path\": \"credentials\"", "\"credentials_path\": \"#{var}/sftpgo/credentials\""
    end
    bin.install "sftpgo"
    pkgetc.install "sftpgo.json"
    pkgshare.install "static", "templates", "openapi"
    (var/"sftpgo").mkpath
  end

  def caveats
    <<~EOS
      If this is your first installation please open the web administration panel:

      http://localhost:8080/web/admin

      and complete the initial setup.

      The SFTP service is available on port 2022.
      If the SFTPGo service does not start, make sure that TCP ports 2022 and 8080 are not used by other services
      or change the SFTPGo configuration to suit your needs.

      SFTPGo service runs as user "#{ENV["USER"]}".

      Default data location:

      #{var}/sftpgo

      Configuration file location:

      #{pkgetc}/sftpgo.json

      Getting started guide:

      https://github.com/drakkan/sftpgo/blob/main/docs/howto/getting-started.md

      Step-to-step tutorials:

      https://github.com/drakkan/sftpgo/tree/main/docs/howto
    EOS
  end

  plist_options startup: true

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>EnvironmentVariables</key>
        <dict>
          <key>SFTPGO_CONFIG_FILE</key>
          <string>#{pkgetc}/sftpgo.json</string>
          <key>SFTPGO_LOG_FILE_PATH</key>
          <string>#{var}/sftpgo/log/sftpgo.log</string>
          <key>SFTPGO_HTTPD__TEMPLATES_PATH</key>
          <string>#{pkgshare}/templates</string>
          <key>SFTPGO_SMTP__TEMPLATES_PATH</key>
          <string>#{pkgshare}/templates</string>
          <key>SFTPGO_HTTPD__STATIC_FILES_PATH</key>
          <string>#{pkgshare}/static</string>
          <key>SFTPGO_HTTPD__OPENAPI_PATH</key>
          <string>#{pkgshare}/openapi</string>
        </dict>
        <key>WorkingDirectory</key>
        <string>#{var}/sftpgo</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/sftpgo</string>
          <string>serve</string>
        </array>
        <key>UserName</key>
        <string>#{ENV["USER"]}</string>
        <key>KeepAlive</key>
        <true/>
        <key>ThrottleInterval</key>
        <integer>10</integer>
      </dict>
      </plist>
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sftpgo -v")
  end
end
