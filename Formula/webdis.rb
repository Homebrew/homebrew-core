class Webdis < Formula
  desc "Redis HTTP interface with JSON output"
  homepage "https://webd.is/"
  url "https://github.com/nicolasff/webdis/archive/0.1.4.tar.gz"
  sha256 "2e384eae48cfc2e4503e3311c61d4790e5d3b3ab5cf82ec554c0bef5d84c6807"

  bottle do
    cellar :any
    sha256 "58a95727b9e25d21fbdd5d4547ec6a419fbde87990e6ce2cfc24b6707a512534" => :high_sierra
    sha256 "19f382600f096b6787d6bacf561edf8e68100ff275bc4c4df157afaa91d8aa3b" => :sierra
    sha256 "07d2d4499db3ad6dcccb16261d8c45e74a8ec4b9d23ecad9e60f31a06ca56559" => :el_capitan
    sha256 "102e1b2a88158fb3ada215c432b1dbbf3d1f1d8a692e784baa9b5277f717dce9" => :yosemite
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
