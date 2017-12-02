class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/v2.4.3.tar.gz"
  sha256 "56a4eb05e0b310b044ae30203dfb63664cdfb520c9c28dac29fa1886ca59cbc2"

  bottle do
    cellar :any
    sha256 "0f724c618ea55140036dafbb1a60f88a0a1a6a38c6d46520196e86dbaf1a86d6" => :high_sierra
    sha256 "54978a0c00a2231cf6c219f40ec41c173783b03403284a9064e4e2961fc02976" => :sierra
    sha256 "b5b300b3e6a4eea81f36f2aaf59822d268f4e780a1288a05cabd8ef1fcb83683" => :el_capitan
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
