class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/v6.19.1.tar.gz"
  sha256 "7add542acd5e91099301ec1f8f4a5d41bd31bd4ba13bfa9e1144c1cd790cfc6a"
  license "GPL-3.0-or-later"
  head "https://github.com/xmrig/xmrig.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_ventura:  "d6cec80eb30c7a7ff4f99978423bcb7d03eb26c55d66e2ce012dc90c051324de"
    sha256                               arm64_monterey: "a8b9c6d7c268f933d72968c2cee3137059540ce01be053dd312c344c9cd4f717"
    sha256                               arm64_big_sur:  "1356c2658808854823655eb92519a81d23596c42941bc8823ee7150bc85b8112"
    sha256                               ventura:        "6623a97cbd00eb0534dac7c9123ea6c2c23edd0095aabfb8ed8543afe8ef446f"
    sha256                               monterey:       "79832403da7a03ecdfbd1d25319cfd872dca6dac2a887001edf728eb83098876"
    sha256                               big_sur:        "19481861a3288ba44192afa33f9937badfb348a4c6c2544c263645186ad482d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "556978b294fe2ca556d8319fab08371b515d51504abcd92c24acdfab4f751324"
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
    require "pty"
    assert_match version.to_s, shell_output("#{bin}/xmrig -V")
    test_server = "donotexist.localhost:65535"
    output = ""
    args = %W[
      --no-color
      --max-cpu-usage=1
      --print-time=1
      --threads=1
      --retries=1
      --url=#{test_server}
    ]
    PTY.spawn(bin/"xmrig", *args) do |r, _w, pid|
      sleep 5
      Process.kill("SIGINT", pid)
      begin
        r.each_line { |line| output += line }
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end

    assert_match(/POOL #1\s+#{Regexp.escape(test_server)} algo auto/, output)

    if OS.mac?
      assert_match "#{test_server} DNS error: \"unknown node or service\"", output
    else
      assert_match "#{test_server} 127.0.0.1 connect error: \"connection refused\"", output
    end
  end
end
