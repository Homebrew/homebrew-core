class Simgrid < Formula
  include Language::Python::Shebang

  desc "Studies behavior of large-scale distributed systems"
  homepage "https://simgrid.org/"
  url "https://gitlab.inria.fr/simgrid/simgrid/-/archive/v4.0/simgrid-v4.0.tar.bz2"
  sha256 "37387a6b4ab230e37fb062d03af3d6bdb9cd0c76b2c3407ae1a344facc814a8f"
  license "LGPL-2.1-only"
  revision 3

  livecheck do
    url :homepage
    regex(/href=.*?simgrid[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "8a9ef744237a4a0dab7f6b8d84516ce35a42f3c6d6de4dd836991549ca0b36c0"
    sha256 arm64_sequoia: "ac101cf85a869860757c25a7463cb30a434e13ea38286f395c684c49d7dc68d6"
    sha256 arm64_sonoma:  "d9ccec719f56ea2a7308a6d1d8c69913d36ca54cd7e5883fd346a22fe03a1997"
    sha256 arm64_ventura: "7368d7542432d8e4de0694962fcbeaa1b59df7cae46cc8f63d84e59b9f10cb0a"
    sha256 sonoma:        "6c39a851afaf0a6b17f63b0dfda24e1432c39099d0394aee8a28584ec05efd30"
    sha256 ventura:       "aa34a2b0439e38f315bc7a644e199025a690725f69085fea7e422ef4911daf22"
    sha256 arm64_linux:   "d304ffe001f4279e64947f237792f2355811c8888fd08bea83155fb9ce81be29"
    sha256 x86_64_linux:  "8e43863d016ee0d290a2f62839f7a69b0d47382670bd32e366f3d4cf3c3e2618"
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
