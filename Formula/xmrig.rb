class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/v2.14.4.tar.gz"
  sha256 "7e827ece5df61ab1e23dda40940ad2f7946dc006fced86836aed3a26dcdc185e"
  revision 1
  head "https://github.com/xmrig/xmrig.git"

  bottle do
    cellar :any
    sha256 "593c36810c6bdb62a1e5b792ad5329ef6bbb83ce930512375c3a96641a93f099" => :catalina
    sha256 "9cfd4cdb1593f0e90867dfce64e82f0979558ddeb89492edb4ef8fb04e865af3" => :mojave
    sha256 "578b70e67019678acc15d0d936a948b7905dab827efbdac4c0e235dc8e00db36" => :high_sierra
    sha256 "b798556ea6f2315521d08d4a9d209191b4b9f64bf26ff9104dca8df07f7561c4" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "libmicrohttpd"
  depends_on "libuv"
  depends_on "openssl@1.1"

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
