class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/v5.5.3.tar.gz"
  sha256 "267a7b7eff22a7f7e5eb93ef1602c65dfe986e19e4f65e8e64fea6596e42835a"
  head "https://github.com/xmrig/xmrig.git"

  bottle do
    sha256 "11edbcb6d4cd5a02f79a30ca63e4dc9e27e28480ba54dd849e309bbe92e60de7" => :catalina
    sha256 "fdf08f2cb456c79a16a3ec7c4de5536aa0843a64779c7ba26760a91f144891b4" => :mojave
    sha256 "6244ef72b2584ab0f6beb4d8d9ec171326972ae65f6d218b596deb022bbfc75f" => :high_sierra
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
             "--threads=1", "--retries=1", "--url=#{test_server}", :out => write
      end
      start_time=Time.now
      loop do
        assert (Time.now - start_time <= timeout), "No server connect after timeout"
        break if read.gets.include? "\] \[#{test_server}\] DNS error: \"unknown node or service\""
      end
    ensure
      Process.kill("SIGINT", pid)
    end
  end
end
