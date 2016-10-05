class Webdis < Formula
  desc "Redis HTTP interface with JSON output"
  homepage "https://webd.is/"
  url "https://github.com/nicolasff/webdis/archive/0.1.2.tar.gz"
  sha256 "8e46093af006e35354f6b3d58a70e3825cd0c074893be318f1858eddbe1cda86"

  bottle do
    cellar :any
    sha256 "17a9d8bb8fcc4f155d45b2a178fd9e23dade1375e8845579389fbbe5ed002e21" => :sierra
    sha256 "39585b1ba1b3a8e34c2a2d08e6e347284fd3dceca217c83638dfb9fa8e684550" => :el_capitan
    sha256 "053f0bf229a602f8fae49b654545826d4c95c5c020f50edd71bfc083a4152d93" => :yosemite
    sha256 "93d36ebff19cbe0c7d50075a3c3c85d3542c105713728808c84bf0d5fa81828f" => :mavericks
  end

  depends_on "libevent"

  def install
    system "make"
    bin.install "webdis"

    inreplace "webdis.prod.json", "/var/log/webdis.log", "#{var}/log/webdis.log"
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
      assert_match(/Server: Webdis/, shell_output("curl --silent -XGET -I http://localhost:7379/PING"))
    ensure
      Process.kill "TERM", server
      Process.wait server
    end
  end
end
