class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/v2.5.0.tar.gz"
  sha256 "f05e07daa870fa341b44821c35860c450bab1131a11ecc87c240128a8b178690"

  bottle do
    cellar :any
    sha256 "99120b8a5c1385c54f949432eb708e9a3e99e229a21d156cd6d24f7ad4551144" => :high_sierra
    sha256 "be401d6c3852b994f8cef9f45a9f8b33e100115520a04f028a1b2b5fc17d6d7b" => :sierra
    sha256 "b2b98f8aa789d65c7fa2ccde8d83dbff665c89279379a54dda862f401d6b07ed" => :el_capitan
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
