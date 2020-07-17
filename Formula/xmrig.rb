class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/v6.3.0.tar.gz"
  sha256 "ec8136637c19f07c29fd1526c4194e52007f48c46f76194fe43a71fbbb73712c"
  license "GPL-3.0"
  head "https://github.com/xmrig/xmrig.git"

  bottle do
    sha256 "9a3e4cb1854044c1d185103793b278e3c7eaed2cb45c9a0d1bf0ce6794deaaa9" => :catalina
    sha256 "7d94b6baef1056f4b8154515d9a9d4255c5af7cf09beeb1954e6bc809fa941b0" => :mojave
    sha256 "8d9e40d80d4077f617751affcebf73b4c055cc4fe808b993c1654b0e5b254bae" => :high_sierra
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
        break if read.gets.include? "#{test_server} DNS error: \"unknown node or service\""
      end
    ensure
      Process.kill("SIGINT", pid)
    end
  end
end
