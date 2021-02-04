class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/v6.8.1.tar.gz"
  sha256 "4129d0fe2c909aa2f514adcd3c471c7feda9a350c44bbaf94bd5fcd5217e8406"
  license "GPL-3.0-or-later"
  head "https://github.com/xmrig/xmrig.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_big_sur: "66e99e58abc037ad83e04cd1e48624c5e482acdf4127c3ba42c40d4a4e1f523e"
    sha256 big_sur:       "f965e5da7b63cafcf268a16299bf10c50eacf356732d7ecdbd360924a81c9f47"
    sha256 catalina:      "87c958b7178bce25fbd8f4c7d932817d9401f84622dd18d667b1d5a823744892"
    sha256 mojave:        "2ad4ed36ae89682a7f7191d66fd4fd3cdb4f85684757363c1a96561149b57328"
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
