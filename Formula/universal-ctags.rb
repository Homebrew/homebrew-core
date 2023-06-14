class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p6.0.20230611.0.tar.gz"
  version "p6.0.20230611.0"
  sha256 "e8a8a2b0fc40d1b57ee53e7ee7173bfabca615a1398a2c84f422b0ec1bd43ac0"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9233601a49eead223c2e82eebf281686420b88bf0977ffd6966870d8dde52f5b"
    sha256 cellar: :any,                 arm64_monterey: "99a70367e2ed69e88c88bc83f188631d12bb89c484a680d55058d8af0e0f5e4a"
    sha256 cellar: :any,                 arm64_big_sur:  "4becee297fc8164816c53252c5be525e06676416e52376596aebb3349ffbda99"
    sha256 cellar: :any,                 ventura:        "b293900aa00e3a1688fdd16b13ac2e4d52942d7cee51776680a9e49262c97f1a"
    sha256 cellar: :any,                 monterey:       "eeffb61f3b6ea72efb8f54d194e6023c2e0524691d8382cab25cd65753fbe742"
    sha256 cellar: :any,                 big_sur:        "ef86bb77cb6a9002bf9ecd6ca7b945213f4d53c3a2707038ded168927a79349a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e1ef9dc6e69765cf3bb9893042a71477b51acd42bd8112b2c3f973ba4d1a650"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "docutils" => :build
  depends_on "pkg-config" => :build
  depends_on "jansson"
  depends_on "libyaml"
  depends_on "pcre2"

  uses_from_macos "libxml2"

  conflicts_with "ctags", because: "this formula installs the same executable as the ctags formula"

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <stdlib.h>

      void func()
      {
        printf("Hello World!");
      }

      int main()
      {
        func();
        return 0;
      }
    EOS
    system bin/"ctags", "-R", "."
    assert_match(/func.*test\.c/, File.read("tags"))
  end
end
