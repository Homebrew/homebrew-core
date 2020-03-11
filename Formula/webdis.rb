class Webdis < Formula
  desc "Redis HTTP interface with JSON output"
  homepage "https://webd.is/"
  url "https://github.com/nicolasff/webdis/archive/0.1.9.tar.gz"
  sha256 "49bbb41d8c6bdbcaf0d849ad463a53f2eb7d99832251df2d78e7f1489b5d0277"

  bottle do
    cellar :any
    sha256 "404e1541ef26a22fd496c2f3b0c145f110b3264f69089793acca8fdd372d4331" => :catalina
    sha256 "6a9197076c07eff2bca44c342d584512686d50d05a8943b96cbca86a12ed77bf" => :mojave
    sha256 "7c78af53a76f221a6dbc1188d2ff8c5d83f315832bc33470a16f485c254bc8b4" => :high_sierra
    sha256 "c04c67e6eaccf8e60a434cf6654348aae9c5790f97ad680f94be4047f3e5d808" => :sierra
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
