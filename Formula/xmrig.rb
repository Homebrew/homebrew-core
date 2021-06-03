class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/v6.12.2.tar.gz"
  sha256 "7baca03d289f108883e5606c1a1d0287baf6a2425def48e5c413200b5db88bfa"
  license "GPL-3.0-or-later"
  head "https://github.com/xmrig/xmrig.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_big_sur: "2ab6966101801442bacf5121f4007247943f49d58654d133574de83b1e19b77e"
    sha256 big_sur:       "fe2129d3dd8e0fbd8614123eb3746c02e07929a9615f64b7dc1593a0e088721a"
    sha256 catalina:      "4a24d76e62e32bc6144f42b7f3cac2ac673dda8b4be02c61dfa9158e2f48d6b7"
    sha256 mojave:        "6cd3453a508f8f3d64252d034b05e96a0adae9f4269f23edcbad7b91b1f03016"
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
