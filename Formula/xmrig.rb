class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/v6.6.1.tar.gz"
  sha256 "eb45de59cf0cacb10fe77661061da1d4be89827ad4715f1adc09a6056288fdd2"
  license "GPL-3.0-or-later"
  head "https://github.com/xmrig/xmrig.git"

  livecheck do
    url "https://github.com/xmrig/xmrig/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 "5d47da4293bc0edee4f83cb17767a3a9b69f68d3cc6318d914108d58ea5d2887" => :big_sur
    sha256 "d9c8cdfa04c4aa1343f6afef08a8d260387c03ba8c1e2bf520589ad78f610fd9" => :catalina
    sha256 "78e334dcfe6cd4f2607090e8efe9bac97a8ff9524c93f8bcf0c73729a62bcd62" => :mojave
    sha256 "53c554c404c556c01af70a5bd46b1b011c6b42179b9bd80be772623e2d9f0335" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "hwloc"
  depends_on "libmicrohttpd"
  depends_on "libuv"
  depends_on "openssl@1.1"

  def install
    mkdir "build" do
      system "cmake", "..", "-DWITH_CN_GPU=OFF", *std_cmake_args
      system "make"
      bin.install "xmrig"
    end
    pkgshare.install "src/config.json"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xmrig -V")
    test_server="donotexist.localhost:65535"
    timeout=10
    begin
      read, write = IO.pipe
      pid = fork do
        exec "#{bin}/xmrig", "--no-color", "--max-cpu-usage=1", "--print-time=1",
             "--threads=1", "--retries=1", "--url=#{test_server}", out: write
      end
      start_time=Time.now
      loop do
        assert (Time.now - start_time <= timeout), "No server connect after timeout"
        break if read.gets.include? "#{test_server} DNS error: \"unknown node or service\""
      end
    ensure
      Process.kill("SIGINT", pid)
    end
  end
end
