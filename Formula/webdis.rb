class Webdis < Formula
  desc "Redis HTTP interface with JSON output"
  homepage "https://webd.is/"
  url "https://github.com/nicolasff/webdis/archive/0.1.18.tar.gz"
  sha256 "05b3786ab120b102b37b510aa2e854bf1ccb4c68b730b7bb1456c60f8e27ed2b"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f8c83408882f42a23810229c011a1b2c42a855ca8d115802645cbdf02af5e376"
    sha256 cellar: :any,                 arm64_big_sur:  "7b6fb29239bd1ecc823c627b2aed17b17a3a747369900883c298dda7658266c9"
    sha256 cellar: :any,                 monterey:       "87f7ff9e6292332d39e2861c4755a839e35f70ed100a1c2055ff351dea7703bb"
    sha256 cellar: :any,                 big_sur:        "3b514fbabc1805463147d6e57e8714a61beea7c562a4543489f62a9f0eb29b34"
    sha256 cellar: :any,                 catalina:       "42647e2db028c4e74ab5a8ec031e267c724bc1d876ff5549ac1ac764fdd746ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e1c131f0f7b34e1108fc2bcdacb752e152dda92f5bf6022d71083e4665d53b5"
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
