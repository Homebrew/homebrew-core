class Webdis < Formula
  desc "Redis HTTP interface with JSON output"
  homepage "https://webd.is/"
  url "https://github.com/nicolasff/webdis/archive/0.1.9.tar.gz"
  sha256 "49bbb41d8c6bdbcaf0d849ad463a53f2eb7d99832251df2d78e7f1489b5d0277"

  bottle do
    cellar :any
    sha256 "0ed607d2f26d3aa40821e3ef20ae493c58cb12b9df4edd4a0720ff3208f8fce1" => :catalina
    sha256 "b00e9c19e7cd7846dae7bab59b8a71b18716195222c7b52a2ad2a8fb79f519f8" => :mojave
    sha256 "906e5885c49a034a676cee68163c749bf1d55df7e26fae1f550bb911ce361bca" => :high_sierra
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

  def plist
    <<~EOS
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
