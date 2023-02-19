class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p6.0.20230219.0.tar.gz"
  version "p6.0.20230219.0"
  sha256 "a99f9d2a6ca834ef189b2a7fbd3c1c9e7fc093010179c3b0943d0e4636437624"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "36fd0b4174baabb2699380fdfb0c5e3b5d9f598f5b55a5e4d1b594734842fe48"
    sha256 cellar: :any,                 arm64_monterey: "935817a8bb78052d9b481ee8da345d3b58fea04d0ed0a44ec43891709f51e5b6"
    sha256 cellar: :any,                 arm64_big_sur:  "f59ad89599f3187b11f1cfe8afae40b3bbf7e5186c3a362523de69fd878250c8"
    sha256 cellar: :any,                 ventura:        "2cce5f088cdac1e36364d0c46c05346997c2f073b2563bb09ee69460824b1d1c"
    sha256 cellar: :any,                 monterey:       "af3a6e012823c4c02079331bf47b58ad94c766c07406e61402052ae1e12ccd8a"
    sha256 cellar: :any,                 big_sur:        "53e01d6206320fe0033666e3307c3130e62135088e8439a7115a26712a25f4f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "283a5d2e33e7f40ef4e8f555e2ff93dae8c9dda77157b124adbdeb64c47006ce"
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
