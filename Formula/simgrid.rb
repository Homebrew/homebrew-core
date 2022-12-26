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
    sha256 arm64_ventura:  "b74f6093252d75c5a740206d86304fd1fdbd469195bb721633b06728fdf7a1de"
    sha256 arm64_monterey: "33cd6310a7561485629e64827eadb35ddcbbb0183a82fa26fb2a0afaf3aac42a"
    sha256 arm64_big_sur:  "8cdde2925ecc32a83433b1b077cc114471c3cbf1d5046022872719c0bc34a8cb"
    sha256 ventura:        "8dc7954e386e31c0f63987aaabb41d6e53549a63ab91f423c9fa8f56df3e5032"
    sha256 monterey:       "f2af0a304c585be6c96ce0ad91d1a42f8064788575076945ab5158b43242b1cf"
    sha256 big_sur:        "b01a3a6c1282a3cec1c34bbe413906b4035ff240d77728f6b2b9d29d4b1c1cb1"
    sha256 catalina:       "63276e960125d3e3a7ad3f505c86fbce9c867a9ee7661fa5c4e7374f71af7838"
    sha256 x86_64_linux:   "aa55ed3f96e318693e5e71fcd780a5bfd7bbc85b6269dd29cbdb3e04c9ef03ab"
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
