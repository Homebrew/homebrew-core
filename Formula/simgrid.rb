class Simgrid < Formula
  desc "Studies behavior of large-scale distributed systems"
  homepage "http://simgrid.gforge.inria.fr"
  url "https://gforge.inria.fr/frs/download.php/file/37294/SimGrid-3.18.tar.gz"
  sha256 "dc8f6223d89326b6a21c99eabc90598fa153d6b0818a63ff5c3ec8726e2257b2"
  revision 1

  bottle do
    sha256 "38bb405c91ab2a693f4ffde4397d6539da585742463c262f297bd80ae2aaebf1" => :high_sierra
    sha256 "612689e0a73ad23a7cc8dc86497dc3b327eab799d16e725afadd4da82ee6d194" => :sierra
    sha256 "44a0cea504a6e2047edcc16fc768011c36fc5a2ad9d6118d50a1aad8bc259f2c" => :el_capitan
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
