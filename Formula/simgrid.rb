class Simgrid < Formula
  include Language::Python::Shebang

  desc "Studies behavior of large-scale distributed systems"
  homepage "https://simgrid.org/"
  url "https://framagit.org/simgrid/simgrid/uploads/6ca357e80bd4d401bff16367ff1d3dcc/simgrid-3.29.tar.gz"
  sha256 "83e8afd653555eeb70dc5c0737b88036c7906778ecd3c95806c6bf5535da2ccf"
  revision 1

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

  def install
    # Avoid superenv shim references
    inreplace "src/smpi/smpicc.in", "@CMAKE_C_COMPILER@", DevelopmentTools.locate(ENV.cc)
    inreplace "src/smpi/smpicxx.in", "@CMAKE_CXX_COMPILER@", DevelopmentTools.locate(ENV.cxx)

    system "cmake", ".",
                    "-Denable_debug=on",
                    "-Denable_compile_optimizations=off",
                    "-Denable_fortran=off",
                    *std_cmake_args
    system "make", "install"

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
