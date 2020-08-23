class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/v6.3.2.tar.gz"
  sha256 "495d93f26f1bc24c35a366d33d7a4fffa25a4b5c1f0396f42d282c67aca90984"
  license "GPL-3.0-or-later"
  head "https://github.com/xmrig/xmrig.git"

  bottle do
    sha256 "849927e31bf9602ddf9474c46bf40e62e9b1c607a7a06b8151990f1270f54da7" => :catalina
    sha256 "ad643ec1cf6c35848c640b3154998b5526b51c9dd930598796503f37637b8b94" => :mojave
    sha256 "0c375d33ada13d7cea8506855a1110f5ad4c07ed9ef87c8e871d9d3a2091a986" => :high_sierra
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
