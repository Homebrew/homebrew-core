class XmrigAmd < Formula
  desc "Monero AMD (OpenCL) miner"
  homepage "https://github.com/xmrig/xmrig-amd"
  url "https://github.com/xmrig/xmrig-amd/archive/v2.8.4.tar.gz"
  sha256 "3bc3669724c67e47a88e3878c1e345a1697aaa28e779afe9b972221bbece9a9d"

  depends_on "cmake" => :build
  depends_on "libmicrohttpd"
  depends_on "libuv"
  depends_on "openssl"

  def install
    mkdir "build" do
      system "cmake", "..", "-DUV_LIBRARY=#{Formula["libuv"].opt_lib}/libuv.dylib",
                            *std_cmake_args
      system "make"
      bin.install "xmrig-amd"
    end
    pkgshare.install "src/config.json"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xmrig-amd -V", 2)
  end
end
