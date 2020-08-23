class Simgrid < Formula
  include Language::Python::Shebang

  desc "Studies behavior of large-scale distributed systems"
  homepage "https://simgrid.org/"
  url "https://framagit.org/simgrid/simgrid/uploads/0365f13697fb26eae8c20fc234c5af0e/SimGrid-3.25.tar.gz"
  sha256 "0b5dcdde64f1246f3daa7673eb1b5bd87663c0a37a2c5dcd43f976885c6d0b46"
  revision 1

  bottle do
    sha256 "5f6acdf27e6f658a180026c72c52b36de25ee08d9eac609f762358277613ae0b" => :catalina
    sha256 "66357d6bbddedef44f1f35db0870592b1d4a1786d4f7ff87417ce0a88e1f0486" => :mojave
    sha256 "9fab4d4bb4eadbb23a20295d29c0fe2bd2823a85790c0287b315d80615eed649" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "graphviz"
  depends_on "pcre"
  depends_on "python@3.8"

  def install
    # Avoid superenv shim references
    inreplace "src/smpi/smpicc.in", "@CMAKE_C_COMPILER@", "/usr/bin/clang"
    inreplace "src/smpi/smpicxx.in", "@CMAKE_CXX_COMPILER@", "/usr/bin/clang++"

    system "cmake", ".",
                    "-Denable_debug=on",
                    "-Denable_compile_optimizations=off",
                    "-Denable_fortran=off",
                    *std_cmake_args
    system "make", "install"

    bin.find { |f| rewrite_shebang detected_python_shebang, f }
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <stdlib.h>
      #include <simgrid/engine.h>

      int main(int argc, char* argv[]) {
        printf("%f", simgrid_get_clock());
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lsimgrid",
                   "-o", "test"
    system "./test"
  end
end
