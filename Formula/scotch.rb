class Scotch < Formula
  desc "Package for graph partitioning, graph clustering, and sparse matrix ordering"
  homepage "https://gitlab.inria.fr/scotch/scotch"
  url "https://gitlab.inria.fr/scotch/scotch/-/archive/v6.1.0/scotch-v6.1.0.tar.bz2"
  sha256 "c288b238b8e9b81d986c240993afd1604063061cc90d8f06872c8e1f70715835"
  license "CECILL-C"
  head "https://gitlab.inria.fr/scotch/scotch.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "929c6ad41f026b0b91bcff864ad824e0fabdfb2eb902a4b94378f3513cbbd630"
    sha256 cellar: :any_skip_relocation, big_sur:       "a20b6a391ef73b1c77a8b2977d734fd310523eed368a96304e2580590c50578d"
    sha256 cellar: :any_skip_relocation, catalina:      "e7d7f7d2027bb60ab03da59681fa0c01fd4046366e240ac9aa442ff0910ce032"
    sha256 cellar: :any_skip_relocation, mojave:        "f89d43dd3271fd05fdc3377a00d412992c91e7a66f1a7a4b92c088df67d118e0"
  end

  depends_on "open-mpi" => :build

  uses_from_macos "bison"
  uses_from_macos "flex"
  uses_from_macos "zlib"

  def install
    cd "src"
    (buildpath/"src").install_symlink "Make.inc/Makefile.inc.i686_mac_darwin10" => "Makefile.inc"
    system "make"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdlib.h>
      #include <stdio.h>

      #include <scotch.h>
      int main(void) {
        int major, minor, patch;
        SCOTCH_version(&major, &minor, &patch);
        printf("%d.%d.%d", major, minor, patch);
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-L#{lib}", "-lscotch"
    assert_match version.to_s, shell_output("./a.out")
  end
end
