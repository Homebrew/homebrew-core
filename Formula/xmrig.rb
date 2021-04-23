class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/v6.12.1.tar.gz"
  sha256 "7570030c4b3e257bda190a100dc59f78b74c823af7561222a99b296f5e7b1ac2"
  license "GPL-3.0-or-later"
  head "https://github.com/xmrig/xmrig.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_big_sur: "62aa016c35c8398d2ea9050eb567ff3869576ccb0b2a15e68e360974494d680e"
    sha256 big_sur:       "66905192d63be76a6e6e02142c989cf5dada23242581a7e0cbb3747c4eb505b0"
    sha256 catalina:      "125989a3738c56d55793c9b697add575e9c8878405c8553ce90f905d2aeef2de"
    sha256 mojave:        "29f69aeab1c28d7f7424c6da93b31dc3d8bbf041787b257332e0c628079a8a24"
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
