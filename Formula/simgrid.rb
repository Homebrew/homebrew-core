class Simgrid < Formula
  desc "Studies behavior of large-scale distributed systems"
  homepage "https://simgrid.org/"
  url "https://framagit.org/simgrid/simgrid/uploads/ddd14d9e34ee36bc90d9107f12480c28/SimGrid-3.24.tar.gz"
  sha256 "c976ed1cbcc7ff136f6d1a8eda7d9ccf090e0e16d5239e6e631047ae9e592921"

  bottle do
    sha256 "c62c2880d97b18feb11bcc8a7b9d3bb4c7c2ed2e40f80d8af1c21c30f3489009" => :catalina
    sha256 "240af507cf808f15e0fe97b484ad2d355345a528a86c7f9383281ab4e608c53a" => :mojave
    sha256 "f540615cee13268687c5ea3c3313f9eda95cc641efba5cad506f60fe2c09d321" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "graphviz"
  depends_on "pcre"
  depends_on "python"

  def install
    system "cmake", ".",
                    "-Denable_debug=on",
                    "-Denable_compile_optimizations=off",
                    "-DCMAKE_C_COMPILER=clang",
                    "-DCMAKE_CXX_COMPILER=clang++",
                    *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <stdlib.h>
      #include <simgrid/msg.h>

      int main(int argc, char* argv[]) {
        printf("%f", MSG_get_clock());
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lsimgrid",
                   "-o", "test"
    system "./test"
  end
end
