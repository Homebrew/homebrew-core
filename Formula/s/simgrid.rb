class Simgrid < Formula
  include Language::Python::Shebang

  desc "Studies behavior of large-scale distributed systems"
  homepage "https://simgrid.org/"
  url "https://gitlab.inria.fr/simgrid/simgrid/-/archive/v4.1/simgrid-v4.1.tar.bz2"
  sha256 "a3d02f52cfb9c2e341c380cd8e3b43da4b4885161d8e96f4b033e0d3cc8af611"
  license "LGPL-2.1-only"
  revision 2

  livecheck do
    url :homepage
    regex(/href=.*?simgrid[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "77b3136c87202cbbcce161d618abe84602c1b96b1e06345f889a49fd4e5ef931"
    sha256 arm64_sequoia: "8a5e0543c8818290db5ec03196186b01233d47ffa23a88c873d7f42c0a7c6350"
    sha256 arm64_sonoma:  "c88ea297908af97ab66431aa39cebb289f5dfac3e13dd9f958f2c125598f2b07"
    sha256 sonoma:        "91b95272182e454700e72b3ba2a2f0250528b07d33dc07025d4182162333b0e1"
    sha256 arm64_linux:   "17b3c64251e4e4822c11d2bc3a11f0e83a54deabf6f1a98cf978bad3ec6be414"
    sha256 x86_64_linux:  "40f48076ff0c3af00505a23f223759d30c4448e4cc9b4415f1386f93deca9662"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "graphviz"

  uses_from_macos "python"

  def install
    # Avoid superenv shim references
    inreplace "src/smpi/smpicc.in", "@CMAKE_C_COMPILER@", DevelopmentTools.locate(ENV.cc)
    inreplace "src/smpi/smpicxx.in", "@CMAKE_CXX_COMPILER@", DevelopmentTools.locate(ENV.cxx)

    # Work around build error: ld: library not found for -lcgraph
    ENV.append "LDFLAGS", "-L#{formula_opt_lib("graphviz")}"

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
