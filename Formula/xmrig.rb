class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/v6.16.4.tar.gz"
  sha256 "245ba47a6b8ae8e9a9df1c055e90f22f944a7d1219416cb30268881d0c0d377b"
  license "GPL-3.0-or-later"
  head "https://github.com/xmrig/xmrig.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_monterey: "7dec3e753a79d58afbbcea902732b94b68750031fb57eac9e7446e871bdf7e4d"
    sha256                               arm64_big_sur:  "d9752740049abcceb88a1f36b373059a809f87bdb50226eb8dc13beb36f414d2"
    sha256                               monterey:       "ed6a11a74d73984f0ab21e13e8de8dd10c1484fde131c6aaa380d01a5d79e92c"
    sha256                               big_sur:        "168639732fe4f0c2dc1d30b01f195cfc5ca78eacccd96d5663978f3230a8f2c7"
    sha256                               catalina:       "dac5221dbbb32d6a92f67489a4e60f44cbb7ef6d141ce97151a26463fe361e25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "078d570abeca3c805325c17b0a3dbbdbb1d977dc94ea6f955e2c29fc9a1ad4b7"
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
