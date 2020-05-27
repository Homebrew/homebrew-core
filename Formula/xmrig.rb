class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/v5.11.2.tar.gz"
  sha256 "9c249d2d2660a0804dc2bfe9e82f281353fc37a6dbefaa1e7bd0bb07e629c787"
  head "https://github.com/xmrig/xmrig.git"

  bottle do
    sha256 "bdd391947682c8f5f22b69d454e34657d9cf7133a86d8f33c1e33a0fa7f47ce1" => :catalina
    sha256 "ce2f00b73d8becaf15396efe15b4ffdb129f9f270dd0b748889440a59c8a7d45" => :mojave
    sha256 "e5ee918177bf9dae2bf403cabf99ad44e10ea423056b3a8b109a0e70e964148f" => :high_sierra
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
