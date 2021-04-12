class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/v6.11.2.tar.gz"
  sha256 "c7dca686dce870d2395bd4c3764c7ad4f62d1ed9e26a83b8ea2ca7c395a75775"
  license "GPL-3.0-or-later"
  head "https://github.com/xmrig/xmrig.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_big_sur: "cc9a8015b912ceceaa51c2fde6004ebddbadeedea7915730b218c2347aa02eea"
    sha256 big_sur:       "51628139ad260b2c5629442dd30bc416d9ad02025ce572c011a5e9716027a760"
    sha256 catalina:      "af40ba76f3262e3c1a3175e6164acd91ebaf8084bad7d0f62c0376853e303626"
    sha256 mojave:        "1fc1b58b2240b471ec711bb9d698432ba6866b9cbf2ca9b9f0fe74681eb40918"
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
