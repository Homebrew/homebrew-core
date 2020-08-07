class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/v6.3.1.tar.gz"
  sha256 "303787c6bd105b37cda8389c89c74caa36b810588f02952728ffb16d5b4514b7"
  license "GPL-3.0"
  head "https://github.com/xmrig/xmrig.git"

  bottle do
    sha256 "6d81a25e263fc6745c9bbf333c3cbbe0ee35fb24a87c75890676895143217fc2" => :catalina
    sha256 "3dcf0f3913b6ee03b9bfe6cac3e800b4d187004cb2707956dfb832d0bb342f0b" => :mojave
    sha256 "509b8ba8d2c6f2e50e150045f8f3146907dae69d146e5c895e1b3d3b63691eb6" => :high_sierra
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
