class Simgrid < Formula
  desc "Studies behavior of large-scale distributed systems"
  homepage "http://simgrid.gforge.inria.fr"
  url "https://gforge.inria.fr/frs/download.php/file/37294/SimGrid-3.18.tar.gz"
  sha256 "dc8f6223d89326b6a21c99eabc90598fa153d6b0818a63ff5c3ec8726e2257b2"

  bottle do
    sha256 "25156b23d0a2779e9d8207266d621c4328d83f1089005969991733e5007bb1d0" => :high_sierra
    sha256 "5b383b0c5f6c6191a4843f7e419ca4739254d96d3c33bcba7cc19e05efd8b537" => :sierra
    sha256 "a9a7b7d60cb9b7f586767d1225bd2a0ca10708285c2fb41ee84d8233b531d288" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "pcre"
  depends_on :python3
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
