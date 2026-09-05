class Reliable < Formula
  desc "Simple packet acknowledgement system for UDP-based protocols"
  homepage "https://github.com/mas-bandwidth/reliable"
  url "https://github.com/mas-bandwidth/reliable/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "89232c846cfa92a9d6c3514f6ebabaf7304bd7ed7e4dfb8bb369d1cdb4a820e1"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "71decdbc070f45eeb1fa0a1bc0b170f4ab6ccdd2195cc871e4ca93c40d889a2d"
    sha256 cellar: :any, arm64_sequoia: "8f8321b26c6e226187a5cb5b47c2dfdb2cb4f658ef3cd6392dd73c9b9580306d"
    sha256 cellar: :any, arm64_sonoma:  "1ad6d161ad6ef5e964b7c4b36a85e486b6e984c3a1664f7f08116b1a1b934acd"
    sha256 cellar: :any, arm64_linux:   "ae5e87ecc15d9cbef770d3aafab2342bf9e985879be63d5a490fc64b831d7a93"
    sha256 cellar: :any, x86_64_linux:  "4a031f5ddd0f36f1f20d16d6d13bb3645d86e3ff988e3774fc2e1ef5f709d8a8"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <reliable.h>
      #include <stdio.h>

      int main() {
        if (reliable_init() != RELIABLE_OK) {
          return 1;
        }
        printf("%s", RELIABLE_VERSION_FULL);
        reliable_term();
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lreliable", "-o", "test"
    assert_equal version.to_s, shell_output("./test")
  end
end
