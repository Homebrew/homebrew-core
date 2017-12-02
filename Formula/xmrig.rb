class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/v2.4.3.tar.gz"
  sha256 "56a4eb05e0b310b044ae30203dfb63664cdfb520c9c28dac29fa1886ca59cbc2"

  bottle do
    cellar :any
    sha256 "5742b2cd0227c225a809addaed2e7d552fccbc99fd9f52381a341622e59a2842" => :high_sierra
    sha256 "067a7f98841ff910160caaad61c0b4977e85221454ecc2d846a467eb130bbbf8" => :sierra
    sha256 "3a274f5c98cd7fb6946e208bf2b4e1a5309ce43f92e937208e188324bef3a937" => :el_capitan
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
