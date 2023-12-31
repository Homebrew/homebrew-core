class Simgrid < Formula
  include Language::Python::Shebang

  desc "Studies behavior of large-scale distributed systems"
  homepage "https://simgrid.org/"
  url "https://gitlab.inria.fr/simgrid/simgrid/-/archive/v3.35/simgrid-v3.35.tar.bz2"
  sha256 "de4c34ea424d99702419736e51cb5ad425dc01502a39f303128483a70405c473"
  license "LGPL-2.1-only"

  livecheck do
    url :homepage
    regex(/href=.*?simgrid[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "53be27a1bf81c8631b9b26b04f67fbff07bc41ef9bb1a167b15d97f17ec3a78e"
    sha256 arm64_ventura:  "1bbf0f021ef5d6e60fdd58e1b855af1ec3a782cf85dd8eca2e9d78124ad67af3"
    sha256 arm64_monterey: "c2943e6a95147389818afa4e9029e7b4301b9681eece29ca36c0ba09ef1ccbe6"
    sha256 sonoma:         "9b5e29b74dd9b97b26c3e4b59727b35998c061e5df831e868d3d2f54df8717f5"
    sha256 ventura:        "74f22942dd5067cddf7abf38de8c8caa6f908a097264c087753a2da7375686be"
    sha256 monterey:       "ef0b2ae3c3307270a97f52086497e815230e822770c03a212f89644c0b0b27d3"
    sha256 x86_64_linux:   "b3ac1bc8b73f25eda91af0734a122ffe9e74f0ba5c8d5197c4b23af3c3c7663e"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "graphviz"

  uses_from_macos "python", since: :catalina

  fails_with gcc: "5"

  def install
    # Avoid superenv shim references
    inreplace "src/smpi/smpicc.in", "@CMAKE_C_COMPILER@", DevelopmentTools.locate(ENV.cc)
    inreplace "src/smpi/smpicxx.in", "@CMAKE_CXX_COMPILER@", DevelopmentTools.locate(ENV.cxx)

    # Work around build error: ld: library not found for -lcgraph
    ENV.append "LDFLAGS", "-L#{Formula["graphviz"].opt_lib}"

    system "cmake", "-S", ".", "-B", "build",
                    "-DPython3_EXECUTABLE=#{which("python3")}",
                    "-Denable_debug=on",
                    "-Denable_compile_optimizations=off",
                    "-Denable_fortran=off",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    rewrite_shebang detected_python_shebang(use_python_from_path: true), *bin.children
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
