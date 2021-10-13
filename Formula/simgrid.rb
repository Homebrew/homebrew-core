class Simgrid < Formula
  include Language::Python::Shebang

  desc "Studies behavior of large-scale distributed systems"
  homepage "https://simgrid.org/"
  url "https://framagit.org/simgrid/simgrid/uploads/6ca357e80bd4d401bff16367ff1d3dcc/simgrid-3.29.tar.gz"
  sha256 "83e8afd653555eeb70dc5c0737b88036c7906778ecd3c95806c6bf5535da2ccf"

  livecheck do
    url :homepage
    regex(/href=.*?simgrid[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "3bcf1b52202b0bf72913983c86bb8d6b5e842cf20c08ff9f30b5e562812d0ec7"
    sha256 big_sur:       "ed874d245adffc5455759d716afea6d4152a37df3296e8689b9b6b43a3f1344a"
    sha256 catalina:      "3553e2e019fe3109b094fd976c9befa272046ebb21856a5a2fd15d95ee054628"
    sha256 mojave:        "d6718c707ad66eba5d138e3289b50d37f43ff3171799a2e25e69e99309d97400"
    sha256 x86_64_linux:  "dd8671e3e11762f09e17db9db5492d221e001854947ac3377ce05aa720c249a9"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "graphviz"
  depends_on "pcre"
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

    bin.find { |f| rewrite_shebang detected_python_shebang, f }
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
