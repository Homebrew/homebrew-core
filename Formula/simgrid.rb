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
    rebuild 1
    sha256 arm64_ventura:  "802eb4e58ef2b7a6c32e5cda9c2a217db56acec16d0b8caa9dc106207cc8c156"
    sha256 arm64_monterey: "75c535fd3154a3917fde30bf2ae0f48be8f1b19bf3c011b9e3ac88e15b67a21d"
    sha256 arm64_big_sur:  "76e6d4f133d4b678f0edda2d456c067ba655c1c8abc3dfd9f9d730bd212e7623"
    sha256 ventura:        "8681bd0c3d92f081f491b02d5374529407ef3472524bdc62579bae65d4ff2aaa"
    sha256 monterey:       "a5db9baf84829ec052d45837a8e1eb2ceaa07067eea0cff309eccc5e69457cb6"
    sha256 big_sur:        "81bd5eab76a7a75adc6328196d6c82e21271c92f5671d9ffeaf298849eeac55b"
    sha256 x86_64_linux:   "f63d6bf8056e1d5c43f4303f448ce5746db2df6ac94baf59512d53854165110e"
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
