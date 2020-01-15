class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/v5.5.0.tar.gz"
  sha256 "60c8cb1f5f638bc2c7dae84c4fc8f097c3ac6530ed771d4c4ef7e281326da9fd"
  head "https://github.com/xmrig/xmrig.git"

  bottle do
    sha256 "9b86b75365fbdf62b9b3a8ee3dac3d0e1cd7097193e1a0a3ce14925489c0dcf9" => :catalina
    sha256 "f5de562e17fb1102bbbda81271839380aebb6e3110f3dd6a4b5ce02b5a792ccc" => :mojave
    sha256 "baa2a5edb09baa856622378b77b509f52adc426288d36406b2734a87ad010354" => :high_sierra
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
