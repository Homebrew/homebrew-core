class Simgrid < Formula
  include Language::Python::Shebang

  desc "Studies behavior of large-scale distributed systems"
  homepage "https://simgrid.org/"
  url "https://gitlab.inria.fr/simgrid/simgrid/-/archive/v3.35/simgrid-v3.35.tar.bz2"
  sha256 "de4c34ea424d99702419736e51cb5ad425dc01502a39f303128483a70405c473"
  license "LGPL-2.1-only"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?simgrid[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "40386ba0790246cd370642864c7f1399a9c18a98f4428228da5311deed576392"
    sha256 arm64_ventura:  "2e469f6b022648f342fab09dae9b3d9cec58ada032bd6703c5978f9be2fff2cd"
    sha256 arm64_monterey: "8eb08fe2755ad9c06f11eaac9728992efce5b6b970030a9ba75a1e488e5b5c08"
    sha256 sonoma:         "871e41f583dad25181d5997eef4bb49e843930928364b3f3f7a7064851530f9a"
    sha256 ventura:        "3904e4db3862d1400fdc923e657224f2b52077ce4ea6b2b64aacfd66d6ac5091"
    sha256 monterey:       "3fea1fdaa76249a434cba7a9845f39a04324c76cd6149a50d4261bead5f2c4fd"
    sha256 x86_64_linux:   "3783a1bdc8dc4d5d5c130cf98b27fe40da6bf02c3fcc39db149b00265b2c32fa"
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
