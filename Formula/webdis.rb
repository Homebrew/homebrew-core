class Webdis < Formula
  desc "Redis HTTP interface with JSON output"
  homepage "https://webd.is/"
  url "https://github.com/nicolasff/webdis/archive/0.1.2.tar.gz"
  sha256 "8e46093af006e35354f6b3d58a70e3825cd0c074893be318f1858eddbe1cda86"
  revision 1

  bottle do
    cellar :any
    sha256 "aaf28e176d3f680662299109c0abbe87986be5ea607142b931af0a8875e3280f" => :sierra
    sha256 "848750355e7ee0c45e4c55a929546ddb708235b0e474a2924492e55190d5b8f9" => :el_capitan
    sha256 "f48e748bee604358406cf0d3083f6c25964e1fc3766d6ae306a7c21a4f51fe27" => :yosemite
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

  def plist; <<-EOS.undent
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
