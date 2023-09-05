class Simgrid < Formula
  include Language::Python::Shebang

  desc "Studies behavior of large-scale distributed systems"
  homepage "https://simgrid.org/"
  url "https://gitlab.inria.fr/simgrid/simgrid/uploads/9bdf42319806680ee59c56210287ee1e/simgrid-3.34.tar.gz"
  sha256 "161f1c6c0ebb588c587aea6388114307bb31b3c6d5332fa3dc678151f1d0564d"
  license "LGPL-2.1-only"

  livecheck do
    url :homepage
    regex(/href=.*?simgrid[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "2f33ab2f6763de557371c73e031f905cede78edb13d05e4303ddf8460bd06fea"
    sha256 arm64_monterey: "d1123201b2ca0a05c204f7656e66a70e13ad113d1076878118005c3340005b7f"
    sha256 arm64_big_sur:  "ced3f4e5ed8965eb888e99ba0d5decbcfc696a72c8b633af482ddeb5d92ddfb0"
    sha256 ventura:        "3b9ef7cb555fc6d93e9bd2592e8d6b726ec442342283c2ce2736f57688995131"
    sha256 monterey:       "706004fb650b0b65fa61016fe1eeff690dec5614e1cecbc47deda950749a1e97"
    sha256 big_sur:        "596008e36e2b953ee077927c8116eefa4cfb5887b05aae0620f83b8303a047e3"
    sha256 x86_64_linux:   "062b75f9346f437ef26f5c844c478d67b43bc9288c7511b626b245a671ed68eb"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "graphviz"
  depends_on "python@3.11"

  fails_with gcc: "5"

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
