class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/v1.3.35.tar.gz"
  sha256 "9d32b26e6bfcc058d98248bf8fc231537e347395dd89cf62bb432b55c5da990d"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e7398936031f588871a1c9f1ba63502657586083e04891adbbe724e2fa4a5407"
    sha256 cellar: :any,                 arm64_monterey: "2e006e6d8f8f64a95168eb45848c4735c2947e1a112b507d09602d81ea80d8ae"
    sha256 cellar: :any,                 arm64_big_sur:  "fc7d514c101514e8c0fad2cdda4156d0f52c66449d79bc49c63ee7a05b8cb1af"
    sha256 cellar: :any,                 ventura:        "e5788e1bea6882cde77f2b738f3cca69569a21eea59a1fdc65dc8cf8f69d2a29"
    sha256 cellar: :any,                 monterey:       "470ff570666d01370002d6c6d4715193ad7baaa3e9f74982602abf9ec9260225"
    sha256 cellar: :any,                 big_sur:        "c283700c2c187899e29d177539ca9a0922bb6c7a3893d628d825784afcb04ae7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dde2f9a07f9c547a2e880bcf1037bcc8629a7e36cca5bb8ecd410b2d1f4197c0"
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
