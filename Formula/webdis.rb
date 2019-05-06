class Webdis < Formula
  desc "Redis HTTP interface with JSON output"
  homepage "https://webd.is/"
  url "https://github.com/nicolasff/webdis/archive/0.1.5.tar.gz"
  sha256 "057e8a50f0e86c118ea5cfa52cdc78061c6919945d16f381dcb9be0c3537b373"

  bottle do
    cellar :any
    sha256 "020842ccb0b317dc21db55f817adb70f15b89626b797652da2ebe9b0b1df67f6" => :mojave
    sha256 "028cebcaa8b89112db22d1495e51c7fc7cbed593961f3f010dba126162d4a5cd" => :high_sierra
    sha256 "f1be754483b0357ab70ad90ffe9d95d70ddbdbd80e818e3519389bbd9990db1b" => :sierra
  end

  depends_on "libevent"

  def install
    system "make"
    bin.install "webdis"

    inreplace "webdis.prod.json" do |s|
      s.gsub! "/var/log/webdis.log", "#{var}/log/webdis.log"
      s.gsub! /daemonize":\s*true/, "daemonize\":\tfalse"
    end

    etc.install "webdis.json", "webdis.prod.json"
  end

  def post_install
    (var/"log").mkpath
  end

  plist_options :manual => "webdis #{HOMEBREW_PREFIX}/etc/webdis.json"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
            <string>#{opt_bin}/webdis</string>
            <string>#{etc}/webdis.prod.json</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <dict>
            <key>SuccessfulExit</key>
            <false/>
        </dict>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
      </dict>
    </plist>
  EOS
  end

  test do
    begin
      server = fork do
        exec "#{bin}/webdis", "#{etc}/webdis.json"
      end
      sleep 0.5
      # Test that the response is from webdis
      assert_match(/Server: Webdis/, shell_output("curl --silent -XGET -I http://localhost:7379/PING"))
    ensure
      Process.kill "TERM", server
      Process.wait server
    end
  end
end
