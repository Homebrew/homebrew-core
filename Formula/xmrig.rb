class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/v6.18.0.tar.gz"
  sha256 "4531a31c0c095fcae18fdef0157f1e2a6694408abbcff6789c8f3cd6ab2c3ca0"
  license "GPL-3.0-or-later"
  head "https://github.com/xmrig/xmrig.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_monterey: "1da1fc4a51baca0ef97dde96ce4574a743892f7abb001ee9a8009783aa0b8a2e"
    sha256                               arm64_big_sur:  "5d21b0a51189c496add0957d7ff2029995c20f6b3ac9199d0ecb35e1177e76c3"
    sha256                               monterey:       "4c2d83937291e552c369743ee8d2cebaa5834756de152e87022d8247431ac01e"
    sha256                               big_sur:        "1756da83146306c303350f6d6764ded50a3c0eca947dca5dce35ec83de791920"
    sha256                               catalina:       "e39c4c45bcdfd052399d7449e2fa38187bcb51a69eff0ea34ed44c07bdbac1a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70d997270b0fa25a71f43f7e278f063c7e95a6cd35751d9f46f0dc4de6342e93"
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
    pattern = "#{test_server} DNS error: \"unknown node or service\""
    if OS.mac?
      assert_match pattern, output
    else
      assert_match Regexp.union(pattern, "#{test_server} connect error: \"connection refused\""), output
    end
  end
end
