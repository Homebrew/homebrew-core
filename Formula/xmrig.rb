class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/v5.11.1.tar.gz"
  sha256 "c0a8cedf42a95f78bb4ca306435f9f1793820e3285d5cd588943c7959e8fb810"
  head "https://github.com/xmrig/xmrig.git"

  bottle do
    sha256 "5d44cdd83ada86a9ebbe02a1602c56873c12ad8dc3898587bb4154a08a127b23" => :catalina
    sha256 "5b9200c8297ba4dec9ccc3aabb25ab5dd30edb821f21a0be98c158dd26c8070e" => :mojave
    sha256 "2e4680b388db283391dd0ab34c79e30cd0848d9dd8b0100b171e28bbbfdfbae5" => :high_sierra
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
