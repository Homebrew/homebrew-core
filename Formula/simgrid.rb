class Simgrid < Formula
  include Language::Python::Shebang

  desc "Studies behavior of large-scale distributed systems"
  homepage "https://simgrid.org/"
  url "https://framagit.org/simgrid/simgrid/uploads/c45f7fd6872b3b0d26b9ba2e607d6e3a/simgrid-3.32.tar.gz"
  sha256 "837764eb81562f04e49dd20fbd8518d9eb1f94df00a4e4555e7ec7fa8aa341f0"
  license "LGPL-2.1-only"
  revision 2

  livecheck do
    url :homepage
    regex(/href=.*?simgrid[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "7dc93f3934c74726a99285ef4d65beb81cfd43a66d3f9e469c16a8a29346842a"
    sha256 arm64_monterey: "e8aa5e8267bf356d648458985ff81d64b9b7d1ea01a5cfcb6289b568efa146ed"
    sha256 arm64_big_sur:  "4943f4d387ef0f95430b873d86838469a8f3cf3c5fef36b5246ab3c34c4f8b6a"
    sha256 ventura:        "8a78774d1ade73860bb358c79b6fe8976e3470692432c22030f48ed3e49b4e88"
    sha256 monterey:       "ddc0966429578dd31c77d8676a5c37536113fc0542f09dfa3c3e0fdc49c0c14f"
    sha256 big_sur:        "d839a154dad1bacc9f7189eee5f3a6b192b30f882cf737232aecdd2b4c33a90d"
    sha256 x86_64_linux:   "d865dfd384b606b72561720a8a7a902ed920f91c54e370674fd338c694b46d30"
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
