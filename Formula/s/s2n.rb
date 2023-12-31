class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "d8c1d8e1142441412434feacb4947ce6430a244dcd8f58921af79b29bd901731"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "adf243b0b2aa17ff94b62e8408f99b2f068b984f98e3b5618de87174e030d055"
    sha256 cellar: :any,                 arm64_ventura:  "78df31391e0ecd613708dc7a2ecff102a413844530b36894ac783ca23ab48ae8"
    sha256 cellar: :any,                 arm64_monterey: "4e1411380db2ea4f6ded40156526bd68238e0a47ea0ef59f41fdd6ab36c8a63a"
    sha256 cellar: :any,                 sonoma:         "ae3716dfc3c5c3670ab23b7d3dad238b9e30247facce70b76d4fbc736dffd9e3"
    sha256 cellar: :any,                 ventura:        "eb1ebcfe00171ebf1968e5b68c5b371026125b290e7067cffb85efc9eef49e7c"
    sha256 cellar: :any,                 monterey:       "d8069cd9323c01c865966e6a768b8f16b4452d237d552e3514720421e400b273"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6968c20d7b85cf339d115e60d4fe559e4abe5ef524e9b0a6441d7b3da92c0f1"
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
