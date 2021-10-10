class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/v6.15.2.tar.gz"
  sha256 "27a6c34ee1bec60f8c49a5e2b97223971f579a26a4632fb64c4a4556b3bb04ae"
  license "GPL-3.0-or-later"
  head "https://github.com/xmrig/xmrig.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_big_sur: "847cea3de3d800162d860e135fecb8ee21841b3b6975e90e4ac6f198005c3803"
    sha256                               big_sur:       "8f2514ff0b38fd09c459a734be93e890dee86e2f4e762c6271488403c3335ee0"
    sha256                               catalina:      "6b7118b93e32d587ec161434016327688e89cbdc4e42ee2a6f7e4b91e1125203"
    sha256                               mojave:        "625bc73835b3fedc17a6151552b88a6ea2fb3204d208f4cdec3ec9a1d79ab3aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2122f5127b89b45cc6a0e82e5062139ee2e35b706ec4475e03c68f2a136eafc4"
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
