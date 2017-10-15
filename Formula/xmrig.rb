class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/v2.4.1.tar.gz"
  sha256 "9bf6eca21d559750605879a0f2e340f32726d24b1a6716c49c34c2bb0a6b7ffe"

  bottle do
    cellar :any
    sha256 "c7dc2f081d5bf3f46010efea041777e3e8795303b9c76efd817d82d3eef91b49" => :high_sierra
    sha256 "70d417d39c54e840fe448b225fdc9d47105488f80c1c521ebd5f4d7118994e1a" => :sierra
    sha256 "c248d43f1e000afb96edd39e6ac85cf89d8ed00fb4bd1a016944f56a148ae769" => :el_capitan
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
