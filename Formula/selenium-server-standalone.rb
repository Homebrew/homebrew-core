class SeleniumServerStandalone < Formula
  desc "Browser automation for testing purposes"
  homepage "http://seleniumhq.org/"
  url "https://selenium-release.storage.googleapis.com/2.53/selenium-server-standalone-2.53.0.jar"
  sha256 "67b88cbfd3b130de6ff3770948f56cc485fd1abb5b7a769397d9050a59b1e036"

  bottle :unneeded

  def install
    libexec.install "selenium-server-standalone-#{version}.jar"
    bin.write_jar_script libexec/"selenium-server-standalone-#{version}.jar", "selenium-server"
  end

  plist_options :manual => "selenium-server -p 4444"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <false/>
      <key>ProgramArguments</key>
      <array>
        <string>/usr/bin/java</string>
        <string>-jar</string>
        <string>#{libexec}/selenium-server-standalone-#{version}.jar</string>
        <string>-port</string>
        <string>4444</string>
      </array>
      <key>ServiceDescription</key>
      <string>Selenium Server</string>
      <key>StandardErrorPath</key>
      <string>#{var}/log/selenium-error.log</string>
      <key>StandardOutPath</key>
      <string>#{var}/log/selenium-output.log</string>
    </dict>
    </plist>
    EOS
  end
end
