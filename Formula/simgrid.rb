class Simgrid < Formula
  desc "Studies behavior of large-scale distributed systems"
  homepage "http://simgrid.gforge.inria.fr"
  url "https://gforge.inria.fr/frs/download.php/file/37602/SimGrid-3.20.tar.gz"
  sha256 "4d4757eb45d87cf18d990d589c31d223b0ea8cf6fcd8c94fca4d38162193cef6"

  bottle do
    sha256 "8c0b44df4f9c237a8ba7751e3c7362c2a9718e3a92d4c55bd2c24fc858e1ed71" => :high_sierra
    sha256 "1c910c345aea71e528869c4e0d33804f24cc57239909443842c9f6387cc9c4c1" => :sierra
    sha256 "2700b47361aa99d64b31e0b6a262e34599d241aea3f26237fd715733126cdba1" => :el_capitan
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
