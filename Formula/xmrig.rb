class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/v2.4.1.tar.gz"
  sha256 "9bf6eca21d559750605879a0f2e340f32726d24b1a6716c49c34c2bb0a6b7ffe"

  bottle do
    cellar :any
    sha256 "53a66419a4ac28110284fdb2975f559f27891c4a8b0df0b100f3eb464147bc80" => :high_sierra
    sha256 "c3c40c56a15fe4ea23048f871d825702d08153ce74836f2b137c79559178d23c" => :sierra
    sha256 "5ab38bf18fb3584780bf7cfda6d6bbbc3aa295b23169afe3aa7eaec1f048492b" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "libmicrohttpd"
  depends_on "libuv"

  def install
    mkdir "build" do
      system "cmake", "..", "-DUV_LIBRARY=#{Formula["libuv"].opt_lib}/libuv.a", *std_cmake_args
      system "make"
      bin.install "xmrig"
    end
  end

  test do
    require "open3"
    test_server="donotexist.localhost:65535"
    timeout=10
    Open3.popen2e("#{bin}/xmrig", "--no-color", "--max-cpu-usage=1", "--print-time=1",
                  "--threads=1", "--retries=1", "--url=#{test_server}") do |stdin, stdouts, _wait_thr|
      start_time=Time.now
      stdin.close_write

      stdouts.each do |line|
        assert (Time.now - start_time <= timeout), "No server connect after timeout"
        break if line.include? "\] \[#{test_server}\] DNS error: \"unknown node or service\""
      end
    end
  end
end
