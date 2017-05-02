class SeleniumServerStandaloneAT245 < Formula
  desc "Automated Browser Control"
  homepage "http://seleniumhq.org/"
  url "https://selenium-release.storage.googleapis.com/2.45/selenium-server-standalone-2.45.0.jar"
  sha256 "1172dfa2d94b43bcbcd9e85c824fd714f2d1ed411b6919a22e7338879fad757b"

  bottle do
    cellar :any_skip_relocation
    sha256 "9e2bc170430f8ff6705f135edbf2727d8362d8b5e2d953ed05d255829c6fafb0" => :sierra
    sha256 "9e2bc170430f8ff6705f135edbf2727d8362d8b5e2d953ed05d255829c6fafb0" => :el_capitan
    sha256 "9e2bc170430f8ff6705f135edbf2727d8362d8b5e2d953ed05d255829c6fafb0" => :yosemite
  end

  def install
    libexec.install "selenium-server-standalone-2.45.0.jar"
    bin.write_jar_script libexec/"selenium-server-standalone-2.45.0.jar", "selenium-server"
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
        <string>#{libexec}/selenium-server-standalone-2.45.0.jar</string>
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
    selenium_version = shell_output("unzip -p #{libexec}/selenium-server-standalone-#{version}.jar META-INF/MANIFEST.MF | sed -nEe '/Selenium-Version:/p'")
    assert_equal "Selenium-Version: #{version}", selenium_version.strip
  end
end
