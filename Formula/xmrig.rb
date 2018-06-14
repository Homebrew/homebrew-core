class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/v2.6.3.tar.gz"
  sha256 "a1a1600050d4db00c5a6efe289d46b4dca0f614fe550e525ded37857cc2ab424"

  bottle do
    cellar :any
    sha256 "ad15667ce5a3b0af93c6782fa4179a7b1d6f87dfdab1707b3d4d0717023898c9" => :high_sierra
    sha256 "37a37effd144a75f9e3910e7def2a2b0a3f63fb13642e8f237e6979ee37ba22a" => :sierra
    sha256 "8e09814cfaffd7fd58bc1f6e549e6de804904bbc2a3d065135c2f00e0d74fea4" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "libmicrohttpd"
  depends_on "libuv"

  def install
    mkdir "build" do
      system "cmake", "..", "-DUV_LIBRARY=#{Formula["libuv"].opt_lib}/libuv.dylib",
                            *std_cmake_args
      system "make"
      bin.install "xmrig"
    end
    pkgshare.install "src/config.json"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xmrig -V", 2)
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
