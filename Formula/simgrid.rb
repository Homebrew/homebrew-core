class Simgrid < Formula
  desc "Studies behavior of large-scale distributed systems"
  homepage "http://simgrid.gforge.inria.fr"
  url "https://gforge.inria.fr/frs/download.php/file/37148/SimGrid-3.17.tar.gz"
  sha256 "f5e44f41983e83f65261598ab0de1909d3a8a3feb77f28e37d38f04631dbb908"

  bottle do
    cellar :any
    rebuild 1
    sha256 "5854edfa8e3b5b75dffe0f7a800fab040a232b1657043b921edaf97d0cd6e740" => :high_sierra
    sha256 "805c0f23b83c5f0808fe810e91d98e8c88a55acc1292481dc4aaa003b43aceb5" => :sierra
    sha256 "37282c46131c5cfed6c3a12be3cb05487b800904a38c46cf3133a5b9a335d2fa" => :el_capitan
    sha256 "ade94652c0b0157914e4a6e1e637cae0fedf57e036245680595d0913e7df815a" => :yosemite
    sha256 "e36538092a178bed8956c4537095a17feb594846ee0dfe72c9baec8e9a52eb80" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "python3" => :build
  depends_on "boost"
  depends_on "pcre"
  depends_on "graphviz"

  def install
    system "cmake", ".",
                    "-Denable_debug=on",
                    "-Denable_compile_optimizations=off",
                    *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
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
