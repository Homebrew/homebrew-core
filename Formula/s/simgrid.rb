class Simgrid < Formula
  include Language::Python::Shebang

  desc "Studies behavior of large-scale distributed systems"
  homepage "https://simgrid.org/"
  url "https://gitlab.inria.fr/simgrid/simgrid/-/archive/v3.35/simgrid-v3.35.tar.bz2"
  sha256 "de4c34ea424d99702419736e51cb5ad425dc01502a39f303128483a70405c473"
  license "LGPL-2.1-only"
  revision 3

  livecheck do
    url :homepage
    regex(/href=.*?simgrid[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "618319ea06ebaa3ea149ba68afd842c2c009c440fff703d824701882fd84412e"
    sha256 arm64_ventura:  "76846ebe4e53d4553222a5c5150de159d90d4389c299a899abedf5ed24e8d7f5"
    sha256 arm64_monterey: "ae604f6395651a8d551cd68308e1da0cf9539bbf75c80a57b7f67e274acc464c"
    sha256 sonoma:         "646c24589419875f137ec500c4adb4a1c9c0edda817344d6074cb21a073eb3f2"
    sha256 ventura:        "a98aa664b98d72e312804ba5556550096ae40a4cef6dca33385444068b80d09b"
    sha256 monterey:       "518d0b3f434601c86e833a67790070810d3b8201344e2df37ba4edb22a7300e2"
    sha256 x86_64_linux:   "16fdd292dc9e9c9a1e1ade21232cdec26bb60f40a19932789a572787dcef824d"
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
