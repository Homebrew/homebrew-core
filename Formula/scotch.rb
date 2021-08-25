class Scotch < Formula
  desc "Package for graph partitioning, graph clustering, and sparse matrix ordering"
  homepage "https://gitlab.inria.fr/scotch/scotch"
  url "https://gitlab.inria.fr/scotch/scotch/-/archive/v6.1.1/scotch-v6.1.1.tar.bz2"
  sha256 "543ab2f8998658e5a6123231bfb3736cfbb939f330c656f8a7913d967a933f00"
  license "CECILL-C"
  head "https://gitlab.inria.fr/scotch/scotch.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a2a88eca7948940c07bc2263143b35be2d0a6d4f66bf3f4bff93ead83a653921"
    sha256 cellar: :any_skip_relocation, big_sur:       "54e1182e94e87f15ba4671dd4611efd9aaf6dfa4c480fc304f40633032a70a19"
    sha256 cellar: :any_skip_relocation, catalina:      "47642fe1c6bfc3da89aa509ac9220d9e27071e30327fb6c607e6473d4cc4d7d4"
    sha256 cellar: :any_skip_relocation, mojave:        "ec79906f2bc0c47ac0989a7d4dcc6a3a7a49021e8a330b1f04a973ed09d01b0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f93fe6e8bcdb31271f7d082915061d6fa2b9e415611a6f52929dbb45a48dd847"
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
