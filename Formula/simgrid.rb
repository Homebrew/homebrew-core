class Simgrid < Formula
  include Language::Python::Shebang

  desc "Studies behavior of large-scale distributed systems"
  homepage "https://simgrid.org/"
  url "https://framagit.org/simgrid/simgrid/uploads/caf09286c8e698d977f11e8f8451ba46/simgrid-3.31.tar.gz"
  sha256 "4b44f77ad40c01cf4e3013957c9cbe39f33dec9304ff0c9c3d9056372ed4c61d"
  revision 2

  livecheck do
    url :homepage
    regex(/href=.*?simgrid[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "7d401bd8da31281321f48a805f556ec8778433a4a44a510e2d1904601f535b06"
    sha256 arm64_big_sur:  "3c4d9143dc7c913da3742a53230240e23444b97ad6792152dd4c642500d05e8f"
    sha256 monterey:       "acf61dd03560d053bff2695ef37a44a45b351b383fa491d93c4190d181df9114"
    sha256 big_sur:        "c1ce395fdbe152df01e411e1e45f964afbe9f295ecd77153e60309f8285c202f"
    sha256 catalina:       "715af6c891c7c666c5a8b5782ac236af14225a26c9f7fbd8ed1715ebf8528a3b"
    sha256 x86_64_linux:   "3e773f8d6297a17a270351489406aa94b0ca0a5ead23159d6bd09239e6c4f6fd"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "graphviz"
  depends_on "python@3.10"

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
