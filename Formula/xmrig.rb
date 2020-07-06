class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/v5.11.3.tar.gz"
  sha256 "7bfc1ec5c6e2ceea61ceb792b1e7bdd6c651097059ee0622306c19597ff7ff82"
  license "GPL-3.0"
  head "https://github.com/xmrig/xmrig.git"

  bottle do
    sha256 "0855edef0e1b3a0f1cb59bc62f9cbfd75751d7283929ad667545643fd2726407" => :catalina
    sha256 "ad7b625ec09681ff6488efe43fbb4a8d6c94098ab0fd71554721d11d3c26c9d0" => :mojave
    sha256 "a325f57032ad09541daac1bc0f9541583d1eb6c850275b4a5fca0b215589e5b5" => :high_sierra
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
