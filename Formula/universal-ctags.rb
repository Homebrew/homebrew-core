class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p5.9.20220220.0.tar.gz"
  version "p5.9.20220220.0"
  sha256 "699d3c08181e2da539e7dbbc6210f9322900d6ba74c28e3f85f5768c01269c8d"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "65a00b0dfa0b0e8e4ab9070a69efd3bea0cd26964f7289c22c30f28fc2c34b7e"
    sha256 cellar: :any,                 arm64_big_sur:  "d2b7a70f2aa1501aa0d2bc0c0789b822397acef37fc7569c8226af4bd2e4eae4"
    sha256 cellar: :any,                 monterey:       "94cd33cb9ca438031a7770bf056d4a1c63baa7d584d87de272e9ad03c2cdf3d5"
    sha256 cellar: :any,                 big_sur:        "8aa1b09c8b810eb20bd55b027cd6d417c56b525430a982ecbb186c2cfa15411c"
    sha256 cellar: :any,                 catalina:       "b66b1ef7124273f4ffc8e210309b23c883334b5d3cc96e46a3f90ccfcf2ed45a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3370b534434e61ce9ae45069deb0e929718995e260f9f9faae6701f3126e0233"
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
