class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/v2.4.4.tar.gz"
  sha256 "4ad514db6bbe214a9d4b9a01d1e4e5252a09554fa28c153dbdfa49a001090142"

  bottle do
    cellar :any
    sha256 "4e28b3a941d9de0c929238a8df37f4827357285ea47a3ea0750d9c8423df8a76" => :high_sierra
    sha256 "c690e06b60a050d6687494c3b2a77db8b68c38aaab3e8ec1578321ccd8b4b417" => :sierra
    sha256 "896467be9a78616b80ec3126e0425d5e6666fcebba95dbc2d63152e14873f06f" => :el_capitan
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
    pkgshare.install "src/config.json"
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
