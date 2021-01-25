class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/v6.7.2.tar.gz"
  sha256 "c843f6639a05893fd02c81319542c919e39871496c52c366f1cad879fb5393ec"
  license "GPL-3.0-or-later"
  head "https://github.com/xmrig/xmrig.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 "6fe5b3f3b7807d8023b59ba47cd4cf85b0ee836147836ab426afec096d8e9038" => :big_sur
    sha256 "a7663915cbb11b5183adbc05f4bb41b480c05b8a4df3f98d544b71e4a732642c" => :arm64_big_sur
    sha256 "32fbe179c02c8bb10a71edaef8e44d2abc1467e4f393922f061bf7bc5eb52a8a" => :catalina
    sha256 "867c9c1f923808315f230f127def37b27affb3cc0018c7ab1c4d93e453d7d073" => :mojave
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
