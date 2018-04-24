class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/v2.5.3.tar.gz"
  sha256 "83ed12e24be15b201d6763dab58020d7eed06462f29c516c99b76a55d46db05e"

  bottle do
    cellar :any
    sha256 "e679efecee1e74e75d7c5f068924cad25e95b443f5a1ec3b8fc2ba0211c26b9e" => :high_sierra
    sha256 "b463b75c156004970fba6a3a2f304e8760666e55a64f6f510f538d5f2b608994" => :sierra
    sha256 "8cae0d0dfdbea29d555fea7b0faa4a648627c534aa92cabe2c2a1a41e533f215" => :el_capitan
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
