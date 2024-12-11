class Simgrid < Formula
  include Language::Python::Shebang

  desc "Studies behavior of large-scale distributed systems"
  homepage "https://simgrid.org/"
  url "https://gitlab.inria.fr/simgrid/simgrid/-/archive/v3.36/simgrid-v3.36.tar.bz2"
  sha256 "408289f3d9b2eb2fb9d4904348437a035c6befa4197028c617ab2ef6e8e1260f"
  license "LGPL-2.1-only"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?simgrid[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "c8cd8c9d34931a263eee8124c86441a7155d0c326f1d57d07bb23d7ffbe69480"
    sha256 arm64_sonoma:   "cfb53c7c04538d063bcca99a645a68f316c5aa4216242605fd289ea965d90289"
    sha256 arm64_ventura:  "0b80a356a9ab5eb95015c1efff95b9b8e4b12c74284329808b2f9573f07967ce"
    sha256 arm64_monterey: "be80cac1b5d7186d57795220631d399bc36b8d63476337c17040ca2faff8fc33"
    sha256 sonoma:         "c9838a28cbfe423b4395272c283ae8d4e380752bfaa7adb0019a1467e9683a8b"
    sha256 ventura:        "b6e87e7233eb2eb3985efbeffc1f2297bfa65bb1fa18077afe5af11ceec4caa8"
    sha256 monterey:       "58a03c6bf7ebdc3757122ba5a1c50d319828bca9992e76867539c042f43e90be"
    sha256 x86_64_linux:   "6a0d24c2dc151ff567612f7540aa083ef681d94b8153928968f2a7456cf1a63f"
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
