class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/v6.7.1.tar.gz"
  sha256 "72202ba211a7554b9a45bb1f633dcf132656fcdb83a778f1754d08d6988ec672"
  license "GPL-3.0-or-later"
  head "https://github.com/xmrig/xmrig.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 "b074058717cf40e67d21be40d6c36c548dbbf724a9e9f9be6670e192fdd8254b" => :big_sur
    sha256 "e4856c6690f953cfd0c2fa11eea309822edd404559ce414107be5d6a94acef54" => :arm64_big_sur
    sha256 "384c50fd560bfa34e51ef02a1e0d232d635daccd75cc81754379aa8a902fa70b" => :catalina
    sha256 "1bcc099dc797311394ab8bd71d6be29110f76c631883762169cf2d50e1988e14" => :mojave
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
