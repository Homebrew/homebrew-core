class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/v6.14.1.tar.gz"
  sha256 "5342632664a01efc7d512ce404f580d9ee380899afb144b4afc05c43e76cf446"
  license "GPL-3.0-or-later"
  head "https://github.com/xmrig/xmrig.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_big_sur: "f9f22c6ec51688ab08c4d5781009d014df2abb3213593c8c5d346374e06fe9cb"
    sha256                               big_sur:       "64a8acf08048c855bfdf22dfa51512617280407617f28e8941be5712324a76c2"
    sha256                               catalina:      "59ad44dbbf217c0b4430fb803c7226dcb2f53b14295dcf2e62de25728b75c4dc"
    sha256                               mojave:        "fe36bc7a8b724b2c94b565093d1560095846cff43d429b41a1bdd147df7e72d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9fbd8ed53e878e2a573beda40672d4ccd9675740551b8c508a87fe979492eb52"
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
