class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/v6.8.0.tar.gz"
  sha256 "c67c59f248fd57c620195cc57ac41b6357852d608ca31c242026126f935dc528"
  license "GPL-3.0-or-later"
  head "https://github.com/xmrig/xmrig.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_big_sur: "f46439b9875cf147a45689b864a1531e2b2bd82c08c8f36c102b887ea54b78e1"
    sha256 big_sur:       "20caf3571c1ba14bad0fbc9b5060d4bbb34f06f4a6f1341015c3ce6fcc827b76"
    sha256 catalina:      "4b5b2477a8136d073fc24e737bed0a617283d9eca47df0eeb7518ddde70353c4"
    sha256 mojave:        "b65d8b11124e27c5ecc77a34ad0499eba8e8010ea97fe16f017c6e81c9ff331a"
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
