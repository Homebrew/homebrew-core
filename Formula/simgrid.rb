class Simgrid < Formula
  include Language::Python::Shebang

  desc "Studies behavior of large-scale distributed systems"
  homepage "https://simgrid.org/"
  url "https://framagit.org/simgrid/simgrid/uploads/c45f7fd6872b3b0d26b9ba2e607d6e3a/simgrid-3.32.tar.gz"
  sha256 "837764eb81562f04e49dd20fbd8518d9eb1f94df00a4e4555e7ec7fa8aa341f0"
  license "LGPL-2.1-only"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?simgrid[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "cde014b5c6bbef517b1f29e4331c8da6dcdc8be1892947a1df6616f37acd0c47"
    sha256 arm64_monterey: "9829c665994f240fe09de35511d2bde57bcb4a9ada5c78c3c480288ac323b5b9"
    sha256 arm64_big_sur:  "94d0d5a6227e6eb3853ebfbf23cd7ba631d7a409ff499627e09c087d1cf7f5f9"
    sha256 ventura:        "3d3d9ea2c40492b40b18de837f8e22c3c8354dddca5e0ca997e32527e66755b4"
    sha256 monterey:       "f4ca28891e2a6a525ea8a4294e926aadd4459f5be8471f6cac6691c45e6eab91"
    sha256 big_sur:        "ea94cf083fdc223ccfd2ad2403081aa6417e89aad51311d31d9200787c975fad"
    sha256 x86_64_linux:   "49e903beb6dfd877396afe3248bd8acd44f22a4956068116e524dc9a13bc806a"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "graphviz"
  depends_on "python@3.11"

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
