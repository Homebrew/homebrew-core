class Simgrid < Formula
  include Language::Python::Shebang

  desc "Studies behavior of large-scale distributed systems"
  homepage "https://simgrid.org/"
  url "https://gitlab.inria.fr/simgrid/simgrid/-/archive/v4.0/simgrid-v4.0.tar.bz2"
  sha256 "37387a6b4ab230e37fb062d03af3d6bdb9cd0c76b2c3407ae1a344facc814a8f"
  license "LGPL-2.1-only"
  revision 4

  livecheck do
    url :homepage
    regex(/href=.*?simgrid[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "57019e3a77440a444c0b607f7b0ba615813081cc50ffe5c78f357e11685a58d8"
    sha256 arm64_sequoia: "311ce37f78084b84f5e3e497c74f62ac5d99c655d85a0466e848e91a2c02d37c"
    sha256 arm64_sonoma:  "f5fe2c61a35337000d127f4b5237d0393a8004c3fc4c4531ceff2bb57d3e3aff"
    sha256 sonoma:        "9d372cba7031c206dc6d2f1f4011d3f5f76553a7e1491c02eaec019328202298"
    sha256 arm64_linux:   "bc77c36a7fe3f309d7617ac655018bb8ecc2266e89ab401feda85fece7410601"
    sha256 x86_64_linux:  "833a6ae831670a92f06682b5a2be2e8992a0db3de31c3cb3f9b1ae5c7cc1a758"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "graphviz"

  uses_from_macos "python"

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
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <stdlib.h>
      #include <simgrid/engine.h>

      int main(int argc, char* argv[]) {
        printf("%f", simgrid_get_clock());
        return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lsimgrid",
                   "-o", "test"
    system "./test"
  end
end
