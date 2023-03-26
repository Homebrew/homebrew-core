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
    sha256                               arm64_ventura:  "8bc807fcbb406bc8f7aa8fb2c4d0eb518fe9b3e81a54b96023bd368f7620cb51"
    sha256                               arm64_monterey: "dc50187009687d75a01f6a10dcf4ef37277b13dece5f2c5683950854ffe7a629"
    sha256                               arm64_big_sur:  "bd8f4045a3a0c5dd39c25230ec0c9ebe095f5b08f61f4c4b53bcd3b76b97330c"
    sha256                               ventura:        "a6bf712780541aa17a033a25c0c39df545aa37361279316c20d693cf902b8063"
    sha256                               monterey:       "feeebf9236eb41268498839a2db2fdca269250f22775d5a1dafe17afaee61278"
    sha256                               big_sur:        "adc47db2f775a65779d1b4643077202c93a2b96925289016c2d46d22920f7b57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e02a77f5ae5893bcf17e12b67b0a5ea98f4f606d5a603011fa7206a1ab01e4cd"
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
