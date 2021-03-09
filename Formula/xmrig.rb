class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/v6.10.0.tar.gz"
  sha256 "6752d2ee2d3eff8f313e7440053ea55e30925ce9665196701d4557a27707c9b7"
  license "GPL-3.0-or-later"
  head "https://github.com/xmrig/xmrig.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_big_sur: "62a635f40497724d76ca2492cf022234569da38f11ecd880b2ed1a51de524117"
    sha256 big_sur:       "71275e53a661c12af7c9719d0cd8d2c9bb6ef731605505892070ef130dba7207"
    sha256 catalina:      "efa0c0860d62be5d821d1fbc0cbbbb7358bdbead68d2f25a23a80a4530d078f1"
    sha256 mojave:        "d27036e0417739b55f658060cf8a3d4cb94a6ab655fc7f2027b315bd61d36552"
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
