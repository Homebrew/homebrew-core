class Simgrid < Formula
  desc "Studies behavior of large-scale distributed systems"
  homepage "http://simgrid.gforge.inria.fr"
  url "https://gforge.inria.fr/frs/download.php/file/37452/SimGrid-3.19.tar.gz"
  sha256 "64a3b82fdf0a65bb8b7c8e9feb01694360edaf38070097bf28aa181eccb86ea7"

  bottle do
    sha256 "5b87d86d1b0cb0a409e55950cb4c4804525171b9b8f93b3363071b9785662e55" => :high_sierra
    sha256 "16252791fbb83e6dc131a363a0be011fdd963aae83258d0ebddb657bd3a010ef" => :sierra
    sha256 "b78374d8e250b55fa80fefa9266ac844b5c309cc3697867956dd57cf07ca43bd" => :el_capitan
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
