class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/v2.14.1.tar.gz"
  sha256 "644168116cd76747c9e1358113598dd039cfac8fccd2b54f84b9d40a9b075c2b"
  head "https://github.com/xmrig/xmrig.git"

  bottle do
    cellar :any
    sha256 "c3533a90c0f3cf99b2fb366aa75f36bd5a2a39a57c1104396f5870425d4103c0" => :mojave
    sha256 "cd26ffa97eafb1909772c886b9698b1b4f9f391571f7fa870195efff0fd06901" => :high_sierra
    sha256 "960e4bc1fecb05814e1535e8afe0eae06f5f91d167035e63c00484a2ffa1c113" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "libmicrohttpd"
  depends_on "libuv"
  depends_on "openssl"

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
