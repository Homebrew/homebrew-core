class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/v2.6.4.tar.gz"
  sha256 "94640ba6d3971a6ba91113ce24a5afec95189cf007f8146011f9a3b367011a69"

  bottle do
    cellar :any
    sha256 "c2e33403253c16a84b4d0ce6585ac0dac5455c6ae0e41c08e8e4a46205b736c2" => :high_sierra
    sha256 "1781a98b2fe2afb042aefd8fb87c6692fa6572dfd55d3c8b8f77c4db275e9c32" => :sierra
    sha256 "bf3459987532ee0e0cc613167487369fe2d98d1270d2c2bc997e485ad738ea55" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "libmicrohttpd"
  depends_on "libuv"

  def install
    mkdir "build" do
      system "cmake", "..", "-DUV_LIBRARY=#{Formula["libuv"].opt_lib}/libuv.dylib",
                            *std_cmake_args
      system "make"
      bin.install "xmrig"
    end
    pkgshare.install "src/config.json"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xmrig -V", 2)
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
