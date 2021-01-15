class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/v6.7.2.tar.gz"
  sha256 "c843f6639a05893fd02c81319542c919e39871496c52c366f1cad879fb5393ec"
  license "GPL-3.0-or-later"
  head "https://github.com/xmrig/xmrig.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 "a412718e6cd444149d1c3085cd2bb9954f3423043a747bdf3fc204d83a911319" => :big_sur
    sha256 "b1a9fb58c8e4d71a89bef45bd1c92427b437066ead44f66a9b692ec6425bc722" => :arm64_big_sur
    sha256 "0dbd6d5c3ca86dfd17c4fc221162ca95b31ce60947808f602a4bebfb5c439fdb" => :catalina
    sha256 "906bff824a7b0bb4bfed5120a0972074bcd487c0e76c349e9d59f38c26e07524" => :mojave
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
