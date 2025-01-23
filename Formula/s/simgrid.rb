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
    sha256 arm64_sequoia: "54a68e0bf87d40ff1e916b5a435bcf49feed3f986ad4be41927e7fac812dd4d2"
    sha256 arm64_sonoma:  "7655403fedb6b333b75d805cc27710c5a74db2c4587f8014a063d03dc346ecf0"
    sha256 arm64_ventura: "4e5f188e958a0df7c16f390f5f841f6ca0910600ffc594cf199b5f2a82dc2f17"
    sha256 sonoma:        "cb12adfc59a96236ee7869c9b66d9777b07ce36895abb7a075a0b4cb6143c012"
    sha256 ventura:       "ef5c294ed30a2a33d80233ac8fab044bc333e5b166d63acc823b812a834a693c"
    sha256 x86_64_linux:  "5ce6ee0872d4bbe238bcee075b8bfc59e870fb5dd8880195957b57e9ef71e18b"
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
