class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/v2.13.1.tar.gz"
  sha256 "ac71836e0320ca73ca7645216b0ed0a2c04497fcfd693225b1da1d29112e30be"

  bottle do
    cellar :any
    sha256 "ba16d9d40716caf249604ce4e2de463c81c5df9c9e7761528260999e6c025cd2" => :mojave
    sha256 "0fc02495b28f28fea5ddc01a5a3a85bc90c9d305b8305922263abb82a037f436" => :high_sierra
    sha256 "897f0e5c27964bf605c7898692e9322a09c514de56a13c3d682ded6fb123ff7f" => :sierra
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
    assert_match version.to_s, shell_output("#{bin}/xmrig -V")
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
