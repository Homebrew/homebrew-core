class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/v6.11.1.tar.gz"
  sha256 "94f8b45c5cd1ff329558f3628d651c3a4688ecb77dd94ea2e5bedfec330349a4"
  license "GPL-3.0-or-later"
  head "https://github.com/xmrig/xmrig.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_big_sur: "a1b87a0f471371f815a0bf0199b821955a862ab3c2a3b546c40495cf9880669f"
    sha256 big_sur:       "5d649c5a6f57a5a2f958de1660316bd11f5dde194f3e4798c7df2d0f347a094d"
    sha256 catalina:      "46e377a2ea001d4c31e1cc41d8801798cc2ffc941de9667aa09462c3cad16d3d"
    sha256 mojave:        "9a88db656c03b569430e435adbb59d4b598fb65a57022490ff4c15c3554bab51"
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
