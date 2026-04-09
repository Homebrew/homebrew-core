class Simgrid < Formula
  include Language::Python::Shebang

  desc "Studies behavior of large-scale distributed systems"
  homepage "https://simgrid.org/"
  url "https://gitlab.inria.fr/simgrid/simgrid/-/archive/v4.1/simgrid-v4.1.tar.bz2"
  sha256 "a3d02f52cfb9c2e341c380cd8e3b43da4b4885161d8e96f4b033e0d3cc8af611"
  license "LGPL-2.1-only"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?simgrid[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "034c76ebb8ad1d5afe856a54ff4cdd3fdeb60dba91ba0273d6008a20b360ca2b"
    sha256 arm64_sequoia: "375e79079d89dc581c9530f1588564ba5ce0db257be5b79985c99aa08a4100da"
    sha256 arm64_sonoma:  "c0ffdf86b7c64b721333f7580ba02c9c794056e0e12e69962b10bc6cd21fe0ee"
    sha256 sonoma:        "13c3d84855a6e9788c77ba476525669d4873291eca0b5b8cd93866782879dee3"
    sha256 arm64_linux:   "dcea28cc28e8c118a7f2ae3c49ffa92a82df38b0feebbd4b9176d2915f6ebe5b"
    sha256 x86_64_linux:  "20872441e0def64e91fe941260e2a627af91e1ac4e8808bb6ebd50a59a852093"
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
