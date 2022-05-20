class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/v6.17.0.tar.gz"
  sha256 "748a989390202ba2d1ccbd9d9a6b8cbd6551149cbab63b347fd1ed6df0254faa"
  license "GPL-3.0-or-later"
  head "https://github.com/xmrig/xmrig.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_monterey: "a003d05e56ecd9168a034b4f45891ab52ab93a854e629f4433c1816f72b24317"
    sha256                               arm64_big_sur:  "41b88534766fd352e53873c97842c459a932c123cfbddc3aabc3a62d32ebc8c9"
    sha256                               monterey:       "1572b95a2018fe4cae59b38354f9cf3a212931a146bfb1b13b1211658d251fcc"
    sha256                               big_sur:        "d6021e38504ee50f39369d0700d5dd30d5a2da3e265614436076af1e2c7d9212"
    sha256                               catalina:       "48c53323accf223f7f3b756b795b07ff53d568c5f0053b6232d74251aaa612d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb324b92d3cb8c231bd6c45a62785d29d31eef7a68d0ee50fdc5367b3be7b08a"
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
