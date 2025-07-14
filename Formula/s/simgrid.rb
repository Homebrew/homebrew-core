class Simgrid < Formula
  include Language::Python::Shebang

  desc "Studies behavior of large-scale distributed systems"
  homepage "https://simgrid.org/"
  url "https://gitlab.inria.fr/simgrid/simgrid/-/archive/v4.0/simgrid-v4.0.tar.bz2"
  sha256 "37387a6b4ab230e37fb062d03af3d6bdb9cd0c76b2c3407ae1a344facc814a8f"
  license "LGPL-2.1-only"
  revision 2

  livecheck do
    url :homepage
    regex(/href=.*?simgrid[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "97834d03436634aab59f86174ba9cd102924e4a2b89e1944390a47d5f6d69814"
    sha256 arm64_sonoma:  "4d315bf4a6fd3e73043b89b650414d247a95e9574653b94bc7be2f07e13280c4"
    sha256 arm64_ventura: "20a58e8118c0b23f13f92c7fccc16900cd37d705dcda79eaf1365ef8eda85b01"
    sha256 sonoma:        "b0e32f937d1ea6de4c77cdfdfe079b2ccfc499bbf2d8b5e3b34b177bca6f7890"
    sha256 ventura:       "b16abf659a7207e2e58cfd0fb434468163c5cea0143965154c33bb249fafcbab"
    sha256 arm64_linux:   "735fa4b077d9dd0adfe026bc74a5300160fa47a90e4c9fe711b47ab81e76c3b5"
    sha256 x86_64_linux:  "5ae6ecd508718ff1155fce1ef7b9e376fd0a63cbe3915215cd5c345634e83fa8"
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
