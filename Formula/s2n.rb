class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/v1.3.45.tar.gz"
  sha256 "7568432191e100140ae718445eafdef731d0eabdbe5e246346a32bd380d4cf1a"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e6255993c385c5525015858c0cfbff22c99a94caa8eb701bc7da34668644d909"
    sha256 cellar: :any,                 arm64_monterey: "88bb3ccf8fa05275ac403a7070a52fc824fea3d2649fae8374b76f6c288f422d"
    sha256 cellar: :any,                 arm64_big_sur:  "ccbcc7748a561a94f17a647f14de707005f9c9451ad0dc04583c5168d8d49a3b"
    sha256 cellar: :any,                 ventura:        "3ce602ea4dae44659b7ab8061396f3c6b9842076b8abb65cbe757f55d0cb7286"
    sha256 cellar: :any,                 monterey:       "3903081793c1a54e677251b4ee71b321c8a2a400899cf7b2a808f61444947f62"
    sha256 cellar: :any,                 big_sur:        "3f339a67041eae98c53eb36658786048062a3fae787fb6ae1241f2568b0820ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec7e302791d8a181e06b63e1f76b83ae673790c473280261786d62a80c86975f"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  def install
    system "cmake", "-S", ".", "-B", "build/static", *std_cmake_args, "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "build/static"
    system "cmake", "--install", "build/static"

    system "cmake", "-S", ".", "-B", "build/shared", *std_cmake_args, "-DBUILD_SHARED_LIBS=ON"
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"
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
