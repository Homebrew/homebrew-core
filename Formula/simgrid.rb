class Simgrid < Formula
  desc "Studies behavior of large-scale distributed systems"
  homepage "http://simgrid.gforge.inria.fr"
  url "https://gforge.inria.fr/frs/download.php/file/37294/SimGrid-3.18.tar.gz"
  sha256 "dc8f6223d89326b6a21c99eabc90598fa153d6b0818a63ff5c3ec8726e2257b2"
  revision 1

  bottle do
    sha256 "65077045d23efb3f98e552fd09e85936585a51b27e39b6f6869a3155df7c9cd4" => :high_sierra
    sha256 "361a6fa13a7be0f14328badb75ec735ec49f48dcb1d0f35976f0c70291b513fb" => :sierra
    sha256 "48dbb7c0494f6599170f9d68c9c262051b472ccbce8b7e2736640ddad5e4ba82" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "pcre"
  depends_on "python3"
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
