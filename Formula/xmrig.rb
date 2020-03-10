class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/v5.9.0.tar.gz"
  sha256 "d08fe47bd5c03d7a9e9bcc36ce940a8fc07f802712303d1fc70c20bd80ef695c"
  head "https://github.com/xmrig/xmrig.git"

  bottle do
    sha256 "b3334b27e040c343313adf7684e13fcdb91f1e3749beee1d6f4c53c6f96f839f" => :catalina
    sha256 "583caa7c6574778ec9d1253cbb81cc48a6dda8e3c0a013ab5baab2d24102c51c" => :mojave
    sha256 "17912f9f98420fb81d86c58e461329e44161fa17ee59cf2fe28f1ac900462218" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "hwloc"
  depends_on "libmicrohttpd"
  depends_on "libuv"
  depends_on "openssl@1.1"

  def install
    mkdir "build" do
      system "cmake", "..", "-DWITH_CN_GPU=OFF", *std_cmake_args
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
