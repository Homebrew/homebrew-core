class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/v6.13.1.tar.gz"
  sha256 "c444e53f8692ad10e0daa73df57892cf9a066d20fe25db377022cd481b1440ad"
  license "GPL-3.0-or-later"
  head "https://github.com/xmrig/xmrig.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_big_sur: "10fbbd388ef3c2e7f522e72295a889da9c471927ecec7a18ef3cf98feaf574b5"
    sha256 big_sur:       "abd939cf867917b9fdac412f0e0a2886d8f847eff5e0a0db4e5a7beffae100c0"
    sha256 catalina:      "d7de732699e3afa96dd4125e054b3b987070912fb33cb66ab64ad3c99cefbf1e"
    sha256 mojave:        "001d61e8bade0bb74db988334e9c6ae32a451dd037c14b55a8f984263e504e16"
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
