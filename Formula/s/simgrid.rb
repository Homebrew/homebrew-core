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
    sha256 arm64_sequoia: "7e6aa7126178cafb4b01bcc2f1daf2b12b991fccda770a22f6ea0e17480f0657"
    sha256 arm64_sonoma:  "f2fd4c6eef2ff11c0238ceaa3e6198c14b264e99cd13051846c4a3a6f040fbae"
    sha256 arm64_ventura: "d7464c3e3e5313884d7ab7b838d7e95948cfdebace0076a25406ce1226c3d00d"
    sha256 sonoma:        "e85dc2beecf07d411d213a8151e8b8cfbb254762af70dba308e72b91828b97d8"
    sha256 ventura:       "05083231650bada0eb6ec69b3defb7e15c603b10e571d4fd0b9e64255404303d"
    sha256 arm64_linux:   "e8aae04574e2d73d3f1e6e49f4cde958f58f75e2125818daeaaa126d95abe9ad"
    sha256 x86_64_linux:  "c03febd31c3767687fdf4399b9a6392610a7f8541e8a70818bb18f44920efd9c"
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
