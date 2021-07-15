class Simgrid < Formula
  include Language::Python::Shebang

  desc "Studies behavior of large-scale distributed systems"
  homepage "https://simgrid.org/"
  url "https://framagit.org/simgrid/simgrid/uploads/5d171dff8b988c639fe52baa24952a2c/simgrid-3.28.tar.gz"
  sha256 "558276e7f8135ce520d98e1bafa029c6c0f5c2d0e221a3a5e42c378fe0c5ef2c"

  livecheck do
    url :homepage
    regex(/href=.*?simgrid[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "dbab289fbc454217f97b144d32d441b78fd349da13defaaf504d7f54c663f510"
    sha256 big_sur:       "49e55f07772e9f9658a37ea9b6a81165b0b21848c9fde408a7ffaec0c1d99a1c"
    sha256 catalina:      "42ffd1847e81c70671ca4d27e9068366231b3205b329a02d5f1e0a517bcf945d"
    sha256 mojave:        "d94db131d78f63ff9494f528ca5ae2dff0ad0c9fbc080378080e826dfe368da5"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "graphviz"
  depends_on "pcre"
  depends_on "python@3.9"

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
