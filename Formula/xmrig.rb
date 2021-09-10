class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/v6.15.0.tar.gz"
  sha256 "155ce4b921839525f03ff7fe3ce9d6ecddf4f2a32cae1b0b83b3808c9db39880"
  license "GPL-3.0-or-later"
  head "https://github.com/xmrig/xmrig.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_big_sur: "089f35f1d9c4b0a7fab421f3ebb4e3b6ffd901c54d4872addd9d633a781e01a8"
    sha256                               big_sur:       "cff6462784d686ae4f3b4cde1225cc60bd59282ec4efcaf9a7dad250d0c7a69f"
    sha256                               catalina:      "e5e3bd3fffc38dfa1caca7bbfd723b6c419c0342baeb9af5ec8f6a06dcb2633e"
    sha256                               mojave:        "cd9f40101f44398b3eeadcb0659b3256f189d46cf1560616dd809c73a042d406"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b848dbb4995974edb3b877e41a1b4b1e7216b02916e96bb6a3d09b5d22bbb03"
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
