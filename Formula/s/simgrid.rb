class Simgrid < Formula
  include Language::Python::Shebang

  desc "Studies behavior of large-scale distributed systems"
  homepage "https://simgrid.org/"
  url "https://gitlab.inria.fr/simgrid/simgrid/-/archive/v4.0/simgrid-v4.0.tar.bz2"
  sha256 "37387a6b4ab230e37fb062d03af3d6bdb9cd0c76b2c3407ae1a344facc814a8f"
  license "LGPL-2.1-only"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?simgrid[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "7729746a85f9411766323b3e08f526ac0b2a320dc1b43f2f1a047affd33b1834"
    sha256 arm64_sonoma:  "e774550064c55be057b8a02be6c97fb4755bcc96ed518f48e86a2a06f110de6a"
    sha256 arm64_ventura: "c1106a2364c23a426f092e8dba68de4ed5c49ffa9f79221098d6daf5131f167d"
    sha256 sonoma:        "6113c9ce3f7b955d6fb7768a0fdd6550787547bd18cf625bdb70515229193b0a"
    sha256 ventura:       "fd493ba61db4d913bed0de8db44da341e6744ae78f20d3458c2d27094971940a"
    sha256 arm64_linux:   "759f64a8dbd6286b41e49af154aba2c9f4acd1b9ebff34dfddcf34e022b2356f"
    sha256 x86_64_linux:  "ae6cc2a41a6adf416328e3208b6f15f41ff4f3b50e8cf5cd282abe4336604305"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "graphviz"

  uses_from_macos "python", since: :catalina

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
