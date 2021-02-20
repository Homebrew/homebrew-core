class SeleniumServerStandalone < Formula
  desc "Browser automation for testing purposes"
  homepage "https://www.seleniumhq.org/"
  url "https://selenium-release.storage.googleapis.com/3.141/selenium-server-standalone-3.141.59.jar"
  sha256 "acf71b77d1b66b55db6fb0bed6d8bae2bbd481311bcbedfeff472c0d15e8f3cb"
  license "Apache-2.0"
  revision 2

  livecheck do
    url "https://www.selenium.dev/downloads/"
    regex(/href=.*?selenium-server-standalone[._-]v?(\d+(?:\.\d+)+)\.jar/i)
  end

  bottle :unneeded

  depends_on "openjdk"

  def install
    libexec.install "selenium-server-standalone-#{version}.jar"
    bin.write_jar_script libexec/"selenium-server-standalone-#{version}.jar", "selenium-server"
  end

  plist_options manual: "selenium-server -port 4444"

  def plist
    <<~EOS
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
          <string>#{Formula["openjdk"].opt_bin}/java</string>
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

  test do
    port = free_port
    fork { exec "#{bin}/selenium-server -port #{port}" }
    sleep 3
    output = shell_output("curl --silent localhost:#{port}/wd/hub/status")
    output = JSON.parse(output)

    assert_equal 0, output["status"]
    assert_true output["value"]["ready"]
    assert_equal version, output["value"]["build"]["version"]
  end
end
