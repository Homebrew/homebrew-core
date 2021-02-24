class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/v6.9.0.tar.gz"
  sha256 "45af614df183fd83f6ed5e831bb55375854ee7cd4855ed0e6858c2919780d3a6"
  license "GPL-3.0-or-later"
  head "https://github.com/xmrig/xmrig.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_big_sur: "febbcb46a3caca065bf14fbb7610e71461454ab7682bca786dd02bc923d0e3cf"
    sha256 big_sur:       "eac7f10785745291a0092b2a6362f98a72fd87f2bb85c6823149347d62041e70"
    sha256 catalina:      "4177ea22c57e07b363d7c1b2a4944bfc61724f962461af052da5ff10bc9ef393"
    sha256 mojave:        "ea8804a313362a8f51d16967f02fd781a3d7edb852562a2fb1807e82d420d5f3"
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
