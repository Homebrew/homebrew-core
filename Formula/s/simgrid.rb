class Simgrid < Formula
  include Language::Python::Shebang

  desc "Studies behavior of large-scale distributed systems"
  homepage "https://simgrid.org/"
  url "https://gitlab.inria.fr/simgrid/simgrid/-/archive/v4.1/simgrid-v4.1.tar.bz2"
  sha256 "a3d02f52cfb9c2e341c380cd8e3b43da4b4885161d8e96f4b033e0d3cc8af611"
  license "LGPL-2.1-only"
  revision 3

  livecheck do
    url :homepage
    regex(/href=.*?simgrid[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "44fe3117ec46b9c25d779eb7989bdfe0821d6ce9e8e47ed34802bded67aac15f"
    sha256 arm64_tahoe:       "bcf91f84735c132eb5b5cf75be878af982f1b73c1a56f3699963cbf800240843"
    sha256 arm64_sequoia:     "e5b23d1ca8ab7b0967063337ebf71a8378564474f3450dc818f4dae4aa67d960"
    sha256 arm64_sonoma:      "73ef5cfd0c535ebe25f8cc95de5524343c20783c826f9b5c3f024615b90f5b06"
    sha256 arm64_linux:       "df8857e84e37534b8e13991d46a2ab0257333acb8473e4ededecb8ff0c86b17b"
    sha256 x86_64_linux:      "5cb1d4a3f4863eea1fbe27fc12de1ca68ce4511c815cb3b36bd0e29a721e5c8f"
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
