class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p6.0.20230226.0.tar.gz"
  version "p6.0.20230226.0"
  sha256 "edf86cbe8ceae594b8c4a4257c15e340c7f797198d5e658aad8b820f7d04bd99"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "573004a341f10f03c09dee1e7ce606da72909110fd09cb09418f9f0c937fcfcc"
    sha256 cellar: :any,                 arm64_monterey: "7dfb610347ccacfae1f26d7bdebe6fcc4353e144573ad49c54ff1af9be421b33"
    sha256 cellar: :any,                 arm64_big_sur:  "3097e63258f4dd3bbd2b5ae3a8b00fba962736455fcb60e102a3087c37c8b061"
    sha256 cellar: :any,                 ventura:        "8771a09581594767aee3bdb4b1dc227337bf8c8730c3461c6b290db913181658"
    sha256 cellar: :any,                 monterey:       "b6a36e0033ef43df41855c7d4743290f9489dd640efd1b13583a26c976aedeb3"
    sha256 cellar: :any,                 big_sur:        "98766c66427224868f1a7eb6eb63391b46939aa8f2f0d4493e518e631e494ccb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fac857b8e6ec7df615e03786575b28bd93ac3a8646f1ae5fa6ea054f6600f47"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "docutils" => :build
  depends_on "pkg-config" => :build
  depends_on "jansson"
  depends_on "libyaml"

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
