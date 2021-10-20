class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/v6.15.2.tar.gz"
  sha256 "27a6c34ee1bec60f8c49a5e2b97223971f579a26a4632fb64c4a4556b3bb04ae"
  license "GPL-3.0-or-later"
  head "https://github.com/xmrig/xmrig.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_big_sur: "9a9b397c587b50e79182beef82ee4ecd4365cf628103d07831152240eecf358c"
    sha256                               big_sur:       "df95a009bdf8bc868cd7d817a50eca1b2ef89f649db65d9a3f8583761c1cfd25"
    sha256                               catalina:      "ac8b1ce4c8c976ed119aa096a764b0169590e065117b781dc285be920171b738"
    sha256                               mojave:        "61fcadd87fc75e15b4254cc5f9ae838448114ce107d959722462c2d3baeb5f08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fcc0b4ff38b600456b23fd063a595227ece182dc093fa31ba836184c4e4464cb"
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
