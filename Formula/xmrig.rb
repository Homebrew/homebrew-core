class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/v2.14.4.tar.gz"
  sha256 "7e827ece5df61ab1e23dda40940ad2f7946dc006fced86836aed3a26dcdc185e"
  revision 1
  head "https://github.com/xmrig/xmrig.git"

  bottle do
    cellar :any
    sha256 "2a05a2ce6d54579c4bf2d146c4669ef40ed25648fd02ac74c92d585079faed8c" => :mojave
    sha256 "813e654ae09af3044d50f1fdcbea93e13009ccf9f2e1ebb04c512ecbd8fdc377" => :high_sierra
    sha256 "83d020800b9dd01efa05bdea2b36e7658bf6e484da7a29137cb778d849a5c3dd" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "libmicrohttpd"
  depends_on "libuv"
  depends_on "openssl@1.1"

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
