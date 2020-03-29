class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/v5.9.0.tar.gz"
  sha256 "d08fe47bd5c03d7a9e9bcc36ce940a8fc07f802712303d1fc70c20bd80ef695c"
  head "https://github.com/xmrig/xmrig.git"

  bottle do
    sha256 "a84f749f15e65d444968347b95a7f4e7439b0fd0a9776d531a1a557c7fd998d6" => :catalina
    sha256 "a07e60733e836fce899a1740939c4903a48bad1ad6f6b0593ca459d9d3142f4f" => :mojave
    sha256 "e9bd079680e67f45b6d917ec3cb5815c6c8951a1a83404d2a39e0dfceaf05e6c" => :high_sierra
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
