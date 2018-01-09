class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/v2.4.3.tar.gz"
  sha256 "56a4eb05e0b310b044ae30203dfb63664cdfb520c9c28dac29fa1886ca59cbc2"

  bottle do
    cellar :any
    rebuild 1
    sha256 "ea51deb3c528a0822a7eb05b92c0e4dec3ce128602792d784a8cd74fabd4ddbd" => :high_sierra
    sha256 "cc4423bdd5fccc46dde0dc5b4e4b3faff4e006e5fc13a606017f4a8e4853adeb" => :sierra
    sha256 "153a072e84fe3e1dd2a788ded1047066ad7757a8f8c6eb30f7621bdaa47f2da2" => :el_capitan
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
    share.install "src/config.json"
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
