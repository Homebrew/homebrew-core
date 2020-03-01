class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/v5.7.0.tar.gz"
  sha256 "d6bcd15648604572625786cd8476f0dc6822e0c4ad0647cca2962cea90f6a67d"
  head "https://github.com/xmrig/xmrig.git"

  bottle do
    sha256 "f6d7e0a978e25575edd0001815de29ad29d50d024bd3d1130374a4d0870158d2" => :catalina
    sha256 "b3b9afaae316a0d8533dd44c81930d1cbd21a6d3163f36a0f8489529c6c473b8" => :mojave
    sha256 "33f236509adb20bbe96a3b52a5a94f384882d3a50166664cd0497f7ba1894965" => :high_sierra
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
