class Volpack < Formula
  desc "Volume Rendering Library"
  homepage "https://graphics.stanford.edu/software/volpack/"
  url "https://github.com/ferdymercury/volpack/archive/refs/tags/v1.0b5.tar.gz"
  sha256 "027f9b4b77c83e3b3566fa31db119c2f59e304574e4b745e8277987162dcc551"
  license "BSD-3-Clause" # https://graphics.stanford.edu/software/bsd-license.html
  head "https://github.com/ferdymercury/volpack.git", branch: "main"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "--install"
    ENV.append "CFLAGS", "-std=gnu17" # https://salsa.debian.org/med-team/volpack/-/commit/56c2858d10fc5f55647ede7c2217e3b433f26f25
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <volpack.h>
      int main() {
          vpContext *vpc = vpCreateContext();
          vpDestroyContext(vpc);
          return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}",
            "-lvolpack", "-o", "test"
    system "./test"
  end
end
