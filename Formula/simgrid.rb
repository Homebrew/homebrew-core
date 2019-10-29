class Simgrid < Formula
  desc "Studies behavior of large-scale distributed systems"
  homepage "https://simgrid.org/"
  url "https://framagit.org/simgrid/simgrid/uploads/ddd14d9e34ee36bc90d9107f12480c28/SimGrid-3.24.tar.gz"
  sha256 "c976ed1cbcc7ff136f6d1a8eda7d9ccf090e0e16d5239e6e631047ae9e592921"

  bottle do
    sha256 "a9c5cb5da50ab2b224e5d1882834d1e7c4428393e05bec3731823597a2da30e9" => :mojave
    sha256 "75ce382a395f963425946d7f53361fa1143a2b6ca9292c63193e76139bcef91e" => :high_sierra
    sha256 "58895cb0aed9235972377d2460a18c8bc03203212ae8246450c429e837a01bcf" => :sierra
    sha256 "c0a6cf0fba37da1c281cac508bdde38aa4145fe7c50bcc9f466f5521cf95d722" => :el_capitan
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
