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
    sha256 arm64_monterey: "f842c89e78c2cc0e3d8a7be9e86375ad003c27e6b58d98c979de1774276539c3"
    sha256 arm64_big_sur:  "fe40ff68cf7f114399e88f509be1fcf74a83cc5f98876f4152af1c0f0c3f00dd"
    sha256 monterey:       "e94b0a7096d04a00db2edec83439173f1ac884da520ccdb71821a3e28f41e537"
    sha256 big_sur:        "8ef7cfe90c699af81d0ccc7d870d88ed6ba1cb3054ea7c9873f2a261346273d6"
    sha256 catalina:       "619eabbb9f950b247fe0c6b840ec0c47f24965ddf607bd0c5bc08215244a5cd4"
    sha256 x86_64_linux:   "2c8061e2f328aa583babf64b511da54f219a1cdb1b9a2b87a5e1621c1591a679"
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
