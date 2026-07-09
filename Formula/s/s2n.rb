class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://aws.github.io/s2n-tls/usage-guide/"
  url "https://github.com/aws/s2n-tls/archive/refs/tags/v1.7.5.tar.gz"
  sha256 "841f67cb1eb4ce71c829fa12ce940ae33556429c7e137be5c16461999bb7f666"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d3850b784123f542a9edd58fbd416f70caecb9021e33955f072c3b14cdb47182"
    sha256 cellar: :any, arm64_sequoia: "2dde3feb84aaa244956d8535e3366152ff59eef1690dc1bf42c1d19c5da0ba5d"
    sha256 cellar: :any, arm64_sonoma:  "d75cf4ce805d3040f01fa0a6d6aec4d2941ab8dcd0016d2ec6f82490e42e5e22"
    sha256 cellar: :any, sonoma:        "adc10b3a3efd468ae2e110880a59cc3c3c785a0aed17e0888e98fb15c0be23c9"
    sha256 cellar: :any, arm64_linux:   "c2fbf38093444f98e7ab350c70f469e3e6ea2b8ca5b67e1e143b3cf45af432da"
    sha256 cellar: :any, x86_64_linux:  "e3ac1d1cd1a9ae9f72156e39f4752d4011403c0f8d679ab96bbf25cd388005db"
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
