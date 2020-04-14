class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/v5.11.0.tar.gz"
  sha256 "34e9f16c6d045ca5b3e30299545625a4b152000d408739f1a3876ab738fa845e"
  head "https://github.com/xmrig/xmrig.git"

  bottle do
    sha256 "2889415b044fe14ce8bbffc115db0c7bd0e8c17dff863f87912d1ac317bb2aec" => :catalina
    sha256 "de085127e360b1761d2fd11abef7ddf631c8b1d2baf9fa136599bc3a077aefdd" => :mojave
    sha256 "0925619e2433afce92c8f592e1c816c214947c5cc3fd4b708bcbad95f50f8767" => :high_sierra
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
             "--threads=1", "--retries=1", "--url=#{test_server}", :out => write
      end
      start_time=Time.now
      loop do
        assert (Time.now - start_time <= timeout), "No server connect after timeout"
        break if read.gets.include? "\] \[#{test_server}\] DNS error: \"unknown node or service\""
      end
    ensure
      Process.kill("SIGINT", pid)
    end
  end
end
