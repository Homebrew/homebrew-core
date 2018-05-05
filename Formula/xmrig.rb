class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/v2.6.1.tar.gz"
  sha256 "2fc1be3124022acc056cf45b24bacba1622ec63ca53d292820409285527655bc"

  bottle do
    cellar :any
    sha256 "ac10b3296da9a842dc4aaa533fd5375440abae1ef37f75d779ed042e06f9de4f" => :high_sierra
    sha256 "445fb4268e6cb4a5ad922e850f3e3d4bba0bbade0e8b83bf2cb0922cb93c7323" => :sierra
    sha256 "96fbc94836f6539cb895b648fa6602b9defc8759486dc0515e953411aa68e5b5" => :el_capitan
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
