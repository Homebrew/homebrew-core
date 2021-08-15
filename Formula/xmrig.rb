class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/v6.14.1.tar.gz"
  sha256 "5342632664a01efc7d512ce404f580d9ee380899afb144b4afc05c43e76cf446"
  license "GPL-3.0-or-later"
  head "https://github.com/xmrig/xmrig.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_big_sur: "c3d9971946ac0346d29381a2fbfc31846f473cb26f839a1fc75aa4326ff8a984"
    sha256                               big_sur:       "84d5705044bb8b8bc0a9f4463d198f5117fd9b80d26611aab14cead60a18d689"
    sha256                               catalina:      "1eb2e3714a808de28fccd084ba8e0382b0797cb0b24033023df54453a309c5c6"
    sha256                               mojave:        "d1baf3fbcef11492379125df6d5300a0d16b28d34b0956e182a3c0c911c98cc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c940f158762a4013d9c983e5c975b92f823f978c72a3b36d0e0890d06bede7e"
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
             "--threads=1", "--retries=1", "--url=#{test_server}", out: write
      end
      start_time=Time.now
      loop do
        assert (Time.now - start_time <= timeout), "No server connect after timeout"
        break if read.gets.include? "#{test_server} DNS error: \"unknown node or service\""
      end
    ensure
      Process.kill("SIGINT", pid)
    end
  end
end
