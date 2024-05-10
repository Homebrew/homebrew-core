class Simgrid < Formula
  include Language::Python::Shebang

  desc "Studies behavior of large-scale distributed systems"
  homepage "https://simgrid.org/"
  url "https://gitlab.inria.fr/simgrid/simgrid/-/archive/v3.35/simgrid-v3.35.tar.bz2"
  sha256 "de4c34ea424d99702419736e51cb5ad425dc01502a39f303128483a70405c473"
  license "LGPL-2.1-only"
  revision 2

  livecheck do
    url :homepage
    regex(/href=.*?simgrid[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "8d96b3df03cb0acee23b19b114431ee60ce83ff9be7ea7f5c8ef5945a89bde10"
    sha256 arm64_ventura:  "67899be53148fda6745f98f0fd44eecc37d106212d8059ccbb249f955656e3a6"
    sha256 arm64_monterey: "5946e04472ab8d3685a8f67a275697e3aa4443d1fde7a2b4d47a7f74ff3ee493"
    sha256 sonoma:         "ebc1a6c4cefe4348425e42959e81feecd15c84b6d6cb71ac1e1456bbbc5e0984"
    sha256 ventura:        "95789997999efce593fe87226a59230c7d58174fb973ee7dd4ea2af019c26877"
    sha256 monterey:       "e989ee84ea89342b955ee00ac70b2a951720e0a36122e7736da7927258fa0963"
    sha256 x86_64_linux:   "72b3b0404b3dc8cdfbdd8c029ae59ea5456900287c0d6af2b3eacf07c80aeb7a"
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
