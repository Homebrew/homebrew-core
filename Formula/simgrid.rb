class Simgrid < Formula
  include Language::Python::Shebang

  desc "Studies behavior of large-scale distributed systems"
  homepage "https://simgrid.org/"
  url "https://framagit.org/simgrid/simgrid/uploads/98ec9471211bba09aa87d7866c9acead/simgrid-3.26.tar.gz"
  sha256 "ac50da1eacc5a53b094a988a8ecde09962c29320f346b45e74dd32ab9d9f3e96"

  livecheck do
    url "https://framagit.org/simgrid/simgrid.git"
    regex(/^v?(\d+(?:[._]\d+)+)$/i)
  end

  bottle do
    sha256 "e955b530c04845a2411dd827c289ebf3945d45ba00bcc763591f7691ba80becb" => :big_sur
    sha256 "483bcf473f05f337322f46d7d9e42f032eec6eea51dbbc9766616f583117a20f" => :arm64_big_sur
    sha256 "bf748370ffd539df857ae5365563b47a5bf685f6ea7bdcd27c3eaad31bf35d06" => :catalina
    sha256 "64bc790d3fa33e14d1c9f067f4e047df4fbbcd630a439370adfc8ad39ab5ddd3" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "graphviz"
  depends_on "pcre"
  depends_on "python@3.9"

  def install
    # Avoid superenv shim references
    inreplace "src/smpi/smpicc.in", "@CMAKE_C_COMPILER@", "/usr/bin/clang"
    inreplace "src/smpi/smpicxx.in", "@CMAKE_CXX_COMPILER@", "/usr/bin/clang++"

    # FindPythonInterp is broken in CMake 3.19+
    # REMOVE ME AT VERSION BUMP (after 3.25)
    # https://framagit.org/simgrid/simgrid/-/issues/59
    # https://framagit.org/simgrid/simgrid/-/commit/3a987e0a881dc1a0bb5a6203814f7960a5f4b07e
    inreplace "CMakeLists.txt", "include(FindPythonInterp)", ""
    python = Formula["python@3.9"]
    python_version = python.version
    # We removed CMake's ability to find Python, so we have to point to it ourselves
    args = %W[
      -DPYTHONINTERP_FOUND=TRUE
      -DPYTHON_EXECUTABLE=#{python.opt_bin}/python3
      -DPYTHON_VERSION_STRING=#{python_version}
      -DPYTHON_VERSION_MAJOR=#{python_version.major}
      -DPYTHON_VERSION_MINOR=#{python_version.minor}
      -DPYTHON_VERSION_PATCH=#{python_version.patch}
    ]
    # End of local workaround, remove the above at version bump

    system "cmake", ".",
                    "-Denable_debug=on",
                    "-Denable_compile_optimizations=off",
                    "-Denable_fortran=off",
                    *std_cmake_args,
                    *args # Part of workaround, remove at version bump
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
