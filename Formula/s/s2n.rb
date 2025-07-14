class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/refs/tags/v1.5.22.tar.gz"
  sha256 "6903a819d43c1e5457e04ae34f895db97ff3d7bbb7d278fef16bd642178a941e"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1f9ef62b86a4508b9c90453fc5741e648d0d52cd7f01feded8a885f3a1bf6d60"
    sha256 cellar: :any,                 arm64_sonoma:  "786a417b33bcf97f00457c780ee4fd125d19bdc4cf0b00103d7d8e845926ee21"
    sha256 cellar: :any,                 arm64_ventura: "8996a91ddba17487fb1ee9d857d1571cdef202696a0e8619b85197c5802ccd3c"
    sha256 cellar: :any,                 sonoma:        "03d3aa463367584f30899b918b63f692a26a3d342acfcb06512fb6268d0bdbe7"
    sha256 cellar: :any,                 ventura:       "1a5d82f91b99526b4407b746e202cf7b0aed6dc64c33e9d1cc609b332e2a3d0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f32de598d657b1fca9cf1a325f9a12cb94d1f41a0a33e8d2cca9efd18863485"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c415e815cee0ea69da9b0ae81684b705a4ead5aa274210331e06f7611118551a"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

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
