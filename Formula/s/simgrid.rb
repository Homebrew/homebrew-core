class Simgrid < Formula
  include Language::Python::Shebang

  desc "Studies behavior of large-scale distributed systems"
  homepage "https://simgrid.org/"
  url "https://gitlab.inria.fr/simgrid/simgrid/-/archive/v4.1/simgrid-v4.1.tar.bz2"
  sha256 "a3d02f52cfb9c2e341c380cd8e3b43da4b4885161d8e96f4b033e0d3cc8af611"
  license "LGPL-2.1-only"

  livecheck do
    url :homepage
    regex(/href=.*?simgrid[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "4e4d5a3c7fdafbf729d17e570c724caf9da036391e6b925f522cc8ad37fbc215"
    sha256 arm64_sequoia: "70e003f6ee0cf6ed4cfabe4c867da443341e89397facaeb1d1e205c561468d39"
    sha256 arm64_sonoma:  "624bcdbdd0eec8bd8bfd85fbbfa6058cb11bb603f270fd11cdf2e598b14eefe0"
    sha256 sonoma:        "f3a0990e1cc2fa926fae7a60754397016fea655a8d9b26d229c3c9fb77ed852a"
    sha256 arm64_linux:   "83edbb1eeb0ca794146fdefc40058ad4e0b2cc8b2808a83e2bc4c7622da84ca0"
    sha256 x86_64_linux:  "8825d67df69d244ec9b6edd6fb415207b5dc0fe2b5355365ae02e48efeb98ba2"
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
