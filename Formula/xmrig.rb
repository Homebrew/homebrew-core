class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/v5.5.0.tar.gz"
  sha256 "60c8cb1f5f638bc2c7dae84c4fc8f097c3ac6530ed771d4c4ef7e281326da9fd"
  head "https://github.com/xmrig/xmrig.git"

  bottle do
    sha256 "73d679c72ce2f7e7600646dcd866b80c4cc556189c0ef233fe6e90a880d59a18" => :catalina
    sha256 "98b5cca6ce442d52aa27d04fade3ca3e3767f2a05f31a336939f4d3c1fc9d112" => :mojave
    sha256 "a6d0574f089803e91f3c3a5c00dceb68ed428992bf629561575a1e7eefb5b519" => :high_sierra
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
