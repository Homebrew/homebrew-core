class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/v2.4.3.tar.gz"
  sha256 "56a4eb05e0b310b044ae30203dfb63664cdfb520c9c28dac29fa1886ca59cbc2"

  bottle do
    cellar :any
    rebuild 2
    sha256 "ca9d1c680827920b25c737bcbda0f37fb3bc3bcde9c9ec988395ec19ecfcd1a4" => :high_sierra
    sha256 "63f5948698bab51a9581a8d23217c94f296323d70ae73e5f8cba2a68f101629c" => :sierra
    sha256 "7de0959cbd9a37daa3b1db7dac76c6dc174bb98a2a6a21c98e26e2d37fff3492" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "libmicrohttpd"
  depends_on "libuv"

  def install
    mkdir "build" do
      system "cmake", "..", "-DUV_LIBRARY=#{Formula["libuv"].opt_lib}/libuv.a", *std_cmake_args
      system "make"
      bin.install "xmrig"
    end
    pkgshare.install "src/config.json"
  end

  test do
    require "open3"
    test_server="donotexist.localhost:65535"
    timeout=10
    Open3.popen2e("#{bin}/xmrig", "--no-color", "--max-cpu-usage=1", "--print-time=1",
                  "--threads=1", "--retries=1", "--url=#{test_server}") do |stdin, stdouts, _wait_thr|
      start_time=Time.now
      stdin.close_write

      stdouts.each do |line|
        assert (Time.now - start_time <= timeout), "No server connect after timeout"
        break if line.include? "\] \[#{test_server}\] DNS error: \"unknown node or service\""
      end
    end
  end
end
