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
    sha256                               arm64_monterey: "32f3fd687c21621f0a64d65a6703d5943097a88617d67fdc7dc48dbc2641e61d"
    sha256                               arm64_big_sur:  "bd975405078916b254a2d29ba99a217a13fc613c127f5b31f842fe80be77ec0c"
    sha256                               monterey:       "f16c27056f9ceab6a16fb305ed10b187ef015a409ddfd08452f29f9c369bdad5"
    sha256                               big_sur:        "25de38cb34629c93e854f73b1a109f0153aea8d417df6cdb6851944cb54c53ec"
    sha256                               catalina:       "d3009e466747309eb0a544f15d4b6ce1d4f5502ee81c1a65e95203ba24337e32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbdc135a7b8eef69904e3f8d5edc348ec766ecd301208a496c737f2dfaf9fc3f"
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
