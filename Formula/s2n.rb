class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/v1.3.9.tar.gz"
  sha256 "09f03600d45cac99b8495f9c7aa5f70a83b5c02867a3018a1ba9975d53184658"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "bfad7de65578c177fe2e82856e9e3a463c60927f0e29ff0ead0083b0e5a2f370"
    sha256 cellar: :any,                 arm64_big_sur:  "6007fc6279c0a332a9e9f80b2bba55c2386e43ebf23d9b6dc8312ea267ebe815"
    sha256 cellar: :any,                 monterey:       "be7943dcc128fba64a2fd3140330d956227ff5caa2e143e2e2c95c665792e7ca"
    sha256 cellar: :any,                 big_sur:        "5cd8ebc6702efcf69f7de9ea96b9288c6fa897dd825b3d27a4fa769ab1866573"
    sha256 cellar: :any,                 catalina:       "a2373d859a750276ac72414428725128e97d657f47d71ee11cc885c006bdbce8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6bcd55211453e96d3a0f8dc4a4f1d03ec4087133cbeb44430cb89fb0f3e3330a"
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DBUILD_SHARED_LIBS=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <s2n.h>
      int main() {
        assert(s2n_init() == 0);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{opt_lib}", "-ls2n", "-o", "test"
    ENV["S2N_DONT_MLOCK"] = "1" if OS.linux?
    system "./test"
  end
end
