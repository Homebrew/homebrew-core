class Simgrid < Formula
  include Language::Python::Shebang

  desc "Studies behavior of large-scale distributed systems"
  homepage "https://simgrid.org/"
  url "https://framagit.org/simgrid/simgrid/uploads/c45f7fd6872b3b0d26b9ba2e607d6e3a/simgrid-3.32.tar.gz"
  sha256 "837764eb81562f04e49dd20fbd8518d9eb1f94df00a4e4555e7ec7fa8aa341f0"
  license "LGPL-2.1-only"

  livecheck do
    url :homepage
    regex(/href=.*?simgrid[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "786946c2f0eebbd9c3a7af20836ea4f457d5440ebfa91938422e4f96f6751fb6"
    sha256 arm64_big_sur:  "a1802b6a5f075ba0fdbb12b31a61e9eaace553b1e63b09dbd46384ce7f128507"
    sha256 monterey:       "73026209c4d1004ee1a748dc4873392c416eb11244c39e501478bf30b0662175"
    sha256 big_sur:        "3f972bba0c69807a88977c57ea63414b0bfc17a514d63b3e1fa9f45ed56a660a"
    sha256 catalina:       "07288533c6753ae3eb2118424ac27f2f83318d26fe7f9d856f172007665c5923"
    sha256 x86_64_linux:   "c63d92969aeb925a5d72a46dcf741c03959cfe3076bed60d02fc773eee621f25"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "graphviz"
  depends_on "python@3.10"

  fails_with gcc: "5"

  def install
    # Avoid superenv shim references
    inreplace "src/smpi/smpicc.in", "@CMAKE_C_COMPILER@", DevelopmentTools.locate(ENV.cc)
    inreplace "src/smpi/smpicxx.in", "@CMAKE_CXX_COMPILER@", DevelopmentTools.locate(ENV.cxx)

    # Work around build error: ld: library not found for -lcgraph
    ENV.append "LDFLAGS", "-L#{Formula["graphviz"].opt_lib}"

    system "cmake", "-S", ".", "-B", "build",
                    "-Denable_debug=on",
                    "-Denable_compile_optimizations=off",
                    "-Denable_fortran=off",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    rewrite_shebang detected_python_shebang, *bin.children
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
