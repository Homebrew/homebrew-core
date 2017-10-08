class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/v2.4.0.tar.gz"
  sha256 "e5fb6c32fce6b9b1564891596620c454eb122de984562e2eb5b534643f4ca697"

  bottle do
    cellar :any_skip_relocation
    sha256 "81eea7be289bbf25c539eca92d4ad76b6f4799001ccf7e64b60ac347e71b0ab1" => :high_sierra
    sha256 "63a9649a47038d8f1c057cbfdf777b19f4196f5e296a7c75706b7776ca423bae" => :sierra
    sha256 "a671b34185128ce84b902225f65c624811f334075d15fd78e56e7c909e6232c9" => :el_capitan
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
