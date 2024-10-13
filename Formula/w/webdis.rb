class Webdis < Formula
  desc "Redis HTTP interface with JSON output"
  homepage "https://webd.is/"
  url "https://github.com/nicolasff/webdis/archive/refs/tags/0.1.22.tar.gz"
  sha256 "4ee465f85999aeba3743a8ed6c7d79690bffe7a8ffb6c7ddec1d4bb6bd1d8685"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "89dc2354f2b41bc455c2f786e930056fc352095ca52d3d22bb6e37cbc3321afc"
    sha256 cellar: :any,                 arm64_sonoma:   "f13baa947b72dccf1e0d6cd43bedd62a52652a09b504260ad753c7ebc33dea6d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc9a4b2972b379a2eb1b8d17f92dd59605ffdddf80bafbb5eab82a6ee0dc878d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "708958851d482d0d79df358fe54e33e3e9c8b153c9d54c0e58120fa738180c24"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dd82e75ae53372ac7c9c1db084727bc013db727ae55105095c58f02764a7e7a9"
    sha256 cellar: :any,                 sonoma:         "46582e4494e8a853cf25c2238035cce8d129c2a094e4c786c62150a48ed48fac"
    sha256 cellar: :any_skip_relocation, ventura:        "0946d5940af495f94ac3ecdbcd546c8028d7a3f4941832f656f8d5abdec0cd0d"
    sha256 cellar: :any_skip_relocation, monterey:       "343f6bfd9a87ee3dc6b509555ff8f7c3ac813986e10cbe698e03b0c03d640ad6"
    sha256 cellar: :any_skip_relocation, big_sur:        "e1e3894807840f4df17b2824d3dad0f885f94560323630024d2c16b3bb8a55de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da907e42d62719633fa070032c4f2041a65aabbc50cf23538a91ef29a2fe86d0"
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
      exec bin/"webdis", "#{testpath}/webdis.json"
    end
    sleep 0.5
    # Test that the response is from webdis
    assert_match(/Server: Webdis/, shell_output("curl --silent -XGET -I http://localhost:#{port}/PING"))
  ensure
    Process.kill "TERM", server
    Process.wait server
  end
end
