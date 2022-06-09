class Simgrid < Formula
  include Language::Python::Shebang

  desc "Studies behavior of large-scale distributed systems"
  homepage "https://simgrid.org/"
  url "https://framagit.org/simgrid/simgrid/uploads/caf09286c8e698d977f11e8f8451ba46/simgrid-3.31.tar.gz"
  sha256 "4b44f77ad40c01cf4e3013957c9cbe39f33dec9304ff0c9c3d9056372ed4c61d"

  livecheck do
    url :homepage
    regex(/href=.*?simgrid[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "4bedc5fea3d5dbb520cee22cbcc036cfe584421e440a26331b87f4d386584afa"
    sha256 arm64_big_sur:  "93fb5658df73c7e7d2d21d35f0e85842a7238b76a877ddf1d8bad857967e4ead"
    sha256 monterey:       "74f01fd95afbc1fe3fbea4c6a197e0a51be1537208eb8631fa53b4e5bdb0e6bb"
    sha256 big_sur:        "13d9028619e89e1fe01bd05de0e14099f4ceea53db2c0bd08d6448783214e930"
    sha256 catalina:       "9102007d57a733f701515d48ec4eeee8f11220006391b2bd980d08087201a14f"
    sha256 x86_64_linux:   "3cf6c46a933707e71f29be19d5b735b360482fdfdeb6feed76c7c529b9d6f4b5"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "graphviz"
  depends_on "python@3.9"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  # Fix build with graphviz>=3 as headers no longer define NIL macros
  patch do
    url "https://framagit.org/simgrid/simgrid/-/commit/33ef49cf9e1ad1aeea86dca9a009d5a6e15e2920.diff"
    sha256 "3bf50df79fd1f58e1919d0c3fa1cd808d50ed0133712e8d596805f25e27933ea"
  end

  def install
    # Avoid superenv shim references
    inreplace "src/smpi/smpicc.in", "@CMAKE_C_COMPILER@", DevelopmentTools.locate(ENV.cc)
    inreplace "src/smpi/smpicxx.in", "@CMAKE_CXX_COMPILER@", DevelopmentTools.locate(ENV.cxx)

    # Work around build error: ld: library not found for -lcgraph
    ENV.append "LDFLAGS", "-L#{Formula["graphviz"].opt_lib}"

    system "cmake", "-S", ".", "-B", "build",
                    "-Denable_debug=on",
                    "-Denable_compile_optimizations=off",
                    "-Denable_fortran=off",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    rewrite_shebang detected_python_shebang, *bin.children
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
