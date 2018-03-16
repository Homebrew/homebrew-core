class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/v2.5.0.tar.gz"
  sha256 "f05e07daa870fa341b44821c35860c450bab1131a11ecc87c240128a8b178690"

  bottle do
    cellar :any
    sha256 "415b3dc39851d6c904e2f18dc04da8a72bfeaa328d5e148836ad357ced3f83b0" => :high_sierra
    sha256 "9218dbaf4fd98863bcccbc807fcf92755e2305516a207a3ab074d1669f81ed47" => :sierra
    sha256 "ceab3887f140dcad2036837da674ce34a6b62ac2684cfcde43cc2019a2e37d0f" => :el_capitan
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
