class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/v2.6.1.tar.gz"
  sha256 "2fc1be3124022acc056cf45b24bacba1622ec63ca53d292820409285527655bc"

  bottle do
    cellar :any
    sha256 "da24f0b4207f02438186c85cc6e8999105a81ab825c5164ef24b6ae013aa0137" => :high_sierra
    sha256 "5261f3f0f0b72a0cd9e92bcd2e40d4ddcc4af727bb42811382b5e3a498709409" => :sierra
    sha256 "bcdb6de2b996e771bb455202dbe2cce2da405ae9bce7d6b529a588c06923b652" => :el_capitan
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
