class Zmij < Formula
  desc "Fast floating-point-to-string conversion library for C and C++"
  homepage "https://github.com/vitaut/zmij"
  url "https://github.com/vitaut/zmij/archive/refs/tags/v1.2.tar.gz"
  sha256 "13e11c9309fab358d5b6f656050e4f3efa1d20ecf15958ae9055382d07b0268f"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "62d66e334e441e90a5523a174382817d668eab622d20c9b1b700e80aec81c76b"
    sha256 cellar: :any, arm64_tahoe:       "4d0a4759ed511331f2f6ef0b39add6a41ae103972fe27e34c60392f9dbd5b417"
    sha256 cellar: :any, arm64_sequoia:     "a7590743f17917101da42245d6f8f3f9f35c3c7c015c618eb9bb76bc1ec248f5"
    sha256 cellar: :any, arm64_linux:       "1d4bee56fd0eb7b745fe580808bc1cd5326374534df4b73de7fb4b733b352acb"
    sha256 cellar: :any, x86_64_linux:      "96ebfe53b1911767ada47a181dc75118f23dbf816d4c9d576211e2d1dd5756a6"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    args = %w[
      -DZMIJ_TEST=OFF
      -DZMIJ_EXAMPLE=OFF
      -DBUILD_SHARED_LIBS=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cc").write <<~CPP
      #include <zmij.h>
      #include <cstring>
      #include <iostream>

      int main() {
        char buf[zmij::double_buffer_size + 1];
        auto end = zmij::write(buf, sizeof(buf), 1.23456789e-27);
        *end = 0;
        std::cout << buf;
        return std::strcmp(buf, "1.23456789e-27") == 0 ? 0 : 1;
      }
    CPP

    system ENV.cxx, "test.cc", "-I#{include}", "-L#{lib}", "-lzmij", "-o", "test"
    assert_equal "1.23456789e-27", shell_output("./test")
  end
end
