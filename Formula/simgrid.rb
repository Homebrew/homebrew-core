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
    sha256 arm64_monterey: "ab8ee6aa628b82f2cc628cb4a8f0299cbab390b79d0e1dfa8a09b475c7503bad"
    sha256 arm64_big_sur:  "6b1e082b4ba8e6585877d3b6def0ca57e1fc24abb7c5aa84389be5329105b741"
    sha256 monterey:       "82263db7ab647377a8bf118d3b593c0d29d54fb6a779f8fcda51f574a327b32d"
    sha256 big_sur:        "86cacdcbf82d4b9ac7e924f616056e6896d16cd7296f07ca9e35711c4927700e"
    sha256 catalina:       "0dbce7e370ad6966cdd07969af51228614d592ec0abacb02921abde25a833d1c"
    sha256 x86_64_linux:   "0e9b0fc791be94df18265aa74e59e469451866f48cbf323318302b151b75766f"
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
