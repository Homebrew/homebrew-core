class Webdis < Formula
  desc "Redis HTTP interface with JSON output"
  homepage "http://webd.is/"
  url "https://github.com/nicolasff/webdis/archive/0.1.2.tar.gz"
  sha256 "8e46093af006e35354f6b3d58a70e3825cd0c074893be318f1858eddbe1cda86"

  depends_on "libevent"

  def install
    system "make"
    bin.install "webdis"

    inreplace "webdis.prod.json" do |s|
      s.gsub! "/var/log/webdis.log", "#{var}/log/webdis.log"
    end

    etc.install "webdis.json", "webdis.prod.json"
  end

  def post_install
    (var/"log").mkpath
  end

  test do
    begin
      server = fork do
        exec "#{bin}/webdis", "#{etc}/webdis.json"
      end
      sleep 0.5
      # Test that the response is from webdis
      assert_match /Server: Webdis/, shell_output("curl --silent -XGET -I http://localhost:7379/PING")
    ensure
      Process.kill "TERM", server
      Process.wait server
    end
  end
end
