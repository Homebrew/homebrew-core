class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/v2.8.3.tar.gz"
  sha256 "ddf0c273fcf71889989c971c2a27b81a05aa2352a4bc03481730576583de4696"

  bottle do
    cellar :any
    sha256 "e70f6f9e32b7be3cf7785024086965a9075f8a4151dfb096205b97b0feb8c4a7" => :mojave
    sha256 "c9f0cbbb7c761cdedca58ab34aef55b40351da79165583cb068071a3e35b9411" => :high_sierra
    sha256 "294fbd5986b573c9246102aa25f4c5f9b28c91a94c7182be4d65a8221519109c" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "libmicrohttpd"
  depends_on "libuv"
  depends_on "openssl"

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
