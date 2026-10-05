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
    sha256 cellar: :any, arm64_golden_gate: "4be31dff7517cf9f9cf8d388afd3ef6e14faf1a746ae6434f4119dd97e9b2049"
    sha256 cellar: :any, arm64_tahoe:       "a2d84c3cb89a0d510083acc14b9ce4e9a74e7f71c9fec74560ef9fb2c5ebd0b6"
    sha256 cellar: :any, arm64_sequoia:     "d9d9422a4d722c76eacd3420a1ab7dfb278f02c23e6bcb2439dbc8c8d3bd4b03"
    sha256 cellar: :any, arm64_linux:       "647d3bb3b4f3ac059ce1e79038662641770c8f6e770d3102fcf74b8ef51546ba"
    sha256 cellar: :any, x86_64_linux:      "3f75e54da5c8d670d3ea49600cab96e41bb60572c66c81ad20d30315f467cbc3"
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
