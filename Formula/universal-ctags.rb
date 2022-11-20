class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p5.9.20221120.0.tar.gz"
  version "p5.9.20221120.0"
  sha256 "e84f1decf1337f3cf50bba46d1d18022d40b32958f73ebfc617b8f80c4a66886"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "05874fc75f509df30b24c831bd823329d57c88c7dad79158516a63d1f46009b6"
    sha256 cellar: :any,                 arm64_monterey: "b2dc315049aa6f6ac9ee67670b4dd57142506d2c53b3a01a2bdfa1a2b8224b62"
    sha256 cellar: :any,                 arm64_big_sur:  "2050bd3b39f3e590432e1355e7866e3d18db94fbd8bfc49e580cce111eebc6d1"
    sha256 cellar: :any,                 ventura:        "a7ea2d14ad0a1170d7064c576cb5882cbe0e1dcff5b780c32b4232688554bac3"
    sha256 cellar: :any,                 monterey:       "7e043027f871ae1700ea0b267c174b493aedbdecdd19e5739eab55d0251ebbfa"
    sha256 cellar: :any,                 big_sur:        "4170639fe9a2d088aa7c760f4a9c6320ddcfac788d5c1bcfed7fe898dbd00b30"
    sha256 cellar: :any,                 catalina:       "74ab6d290f66c917e6d8fb400c5b3623c59afb9a45d2e9ae9bbac7c91e65758e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e127edd0d8df96cfb78569daec368aa30d7dc3dcfe595d411ea793672da28297"
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
