class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/v6.8.2.tar.gz"
  sha256 "ff8e7f6f5fcddc10831aa643e8614aa423058589ed155245a338eaf2274b24cc"
  license "GPL-3.0-or-later"
  head "https://github.com/xmrig/xmrig.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_big_sur: "ad9fe6f317affc5ed26e5cb411e4fa808ec40c72103d6e88ed2956cb2ebb2db5"
    sha256 big_sur:       "4bd4abbf3696ac0e8ef3033032c740434a0b339ac561ebf5896b89d6a613c25b"
    sha256 catalina:      "95158ae5a2ee36d1e31b0bb06c4e7778056332780fe279104e9006e648243f75"
    sha256 mojave:        "7182c86e830d049428493fd621110faa136db79591e2bb05042d068e6759819d"
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
