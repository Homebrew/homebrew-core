class Simgrid < Formula
  desc "Studies behavior of large-scale distributed systems"
  homepage "http://simgrid.gforge.inria.fr"
  url "https://gforge.inria.fr/frs/download.php/file/37452/SimGrid-3.19.tar.gz"
  sha256 "64a3b82fdf0a65bb8b7c8e9feb01694360edaf38070097bf28aa181eccb86ea7"

  bottle do
    sha256 "0fdb77510c94ccb45487dca315188c0fabcd57afe651ce93e6f5d0ef34b4f0a9" => :high_sierra
    sha256 "49b901896a04966d824811ad77a61c437b8d6c968764e354b0cb29e6e1b4bc91" => :sierra
    sha256 "ba50b4e28aff3bb142a83652af9c1030d6d696d2d065438960bf0978c3d25c59" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "pcre"
  depends_on "python"
  depends_on "graphviz"

  def install
    system "cmake", ".",
                    "-Denable_debug=on",
                    "-Denable_compile_optimizations=off",
                    *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <stdlib.h>
      #include <simgrid/msg.h>

      int main(int argc, char* argv[]) {
        printf("%f", MSG_get_clock());
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-lsimgrid", "-o", "test"
    system "./test"
  end
end
