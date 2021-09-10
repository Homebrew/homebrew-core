class Webdis < Formula
  desc "Redis HTTP interface with JSON output"
  homepage "https://webd.is/"
  url "https://github.com/nicolasff/webdis/archive/0.1.17.tar.gz"
  sha256 "c5e97b17f03e2759e6351581c72e582e28ea8d97210fe178c5851020540962f6"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "7b3e184e84fdd31b0aed68c2f4bd1b318947fdb344d2c1f36759c6bea2ce7b14"
    sha256 cellar: :any,                 big_sur:       "33a5078811ac044bf21ca447260c1beb7e86dbb47f3839e428195698d4a021b0"
    sha256 cellar: :any,                 catalina:      "5961e52d1a4464c1127705803497314ff2c9974d7408d6e99443c36c7f788224"
    sha256 cellar: :any,                 mojave:        "36f98a66206c0638e8b1e2eae4fb9a7ec0a852375bd43f830793cf28f1dfec6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb6c4092bb84f5ff66f72a1866276ab40046f06ee3a22728a5507de48265a521"
  end

  depends_on "libevent"

  def install
    system "make"
    bin.install "webdis"

    inreplace "webdis.prod.json" do |s|
      s.gsub! "/var/log/webdis.log", "#{var}/log/webdis.log"
      s.gsub!(/daemonize":\s*true/, "daemonize\":\tfalse")
    end

    etc.install "webdis.json", "webdis.prod.json"
  end

  def post_install
    (var/"log").mkpath
  end

  service do
    run [opt_bin/"webdis", etc/"webdis.prod.json"]
    keep_alive true
    working_dir var
  end

  test do
    port = free_port
    cp "#{etc}/webdis.json", "#{testpath}/webdis.json"
    inreplace "#{testpath}/webdis.json", "\"http_port\":\t7379,", "\"http_port\":\t#{port},"

    server = fork do
      exec "#{bin}/webdis", "#{testpath}/webdis.json"
    end
    sleep 0.5
    # Test that the response is from webdis
    assert_match(/Server: Webdis/, shell_output("curl --silent -XGET -I http://localhost:#{port}/PING"))
  ensure
    Process.kill "TERM", server
    Process.wait server
  end
end
