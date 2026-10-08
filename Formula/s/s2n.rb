class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://aws.github.io/s2n-tls/usage-guide/"
  url "https://github.com/aws/s2n-tls/archive/refs/tags/v1.7.11.tar.gz"
  sha256 "c3894e86bc09c1923f9ed42edc310d8dd1ca4d0461f037acc56762a274ebe2b1"
  license "Apache-2.0"
  revision 1
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "56f23daff690194fa778a926aa67417c7b975ae427074a0f264c2424ce78ad2f"
    sha256 cellar: :any, arm64_tahoe:       "009179213eeae557f5ac8a7023f7ee009ad6b2c0ed88f903b67a06bc36980aab"
    sha256 cellar: :any, arm64_sequoia:     "5b828216e5ce5d83dec47d91b3c3277f0c9ad3427b9b4b7f7f908dd8b0f80ba2"
    sha256 cellar: :any, arm64_linux:       "165f2c07521c36bc43bbf046848fed27b8d3d888985272390f49fe6812393ba4"
    sha256 cellar: :any, x86_64_linux:      "9cc1ef883f2fd76e508b2bf8647213c7a5be83ddf80418aeef4e09d5664774ca"
  end

  depends_on "cmake" => :build
  depends_on "openssl@4"

  def install
    system "cmake", "-S", ".", "-B", "build_static", "-DBUILD_SHARED_LIBS=OFF", *std_cmake_args
    system "cmake", "--build", "build_static"
    system "cmake", "--install", "build_static"

    system "cmake", "-S", ".", "-B", "build_shared", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build_shared"
    system "cmake", "--install", "build_shared"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <assert.h>
      #include <s2n.h>
      int main() {
        assert(s2n_init() == 0);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{opt_lib}", "-ls2n", "-o", "test"
    ENV["S2N_DONT_MLOCK"] = "1" if OS.linux?
    system "./test"
  end
end
