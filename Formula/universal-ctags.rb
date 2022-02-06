class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p5.9.20220206.0.tar.gz"
  version "p5.9.20220206.0"
  sha256 "49d0b2b56b65b9ed6476b1692cd4ba6eef0437fd96014ebcbb0392092360db73"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "fef81e71c9acc7ee75cc082138abe3d92ef0af0e18bb164c5fb88af63779d2b2"
    sha256 cellar: :any,                 arm64_big_sur:  "d96608ad1f76b80812694b80b8c2345d1d54e2814873a8b475d5af738aa53ada"
    sha256 cellar: :any,                 monterey:       "a5c2ab6be874349d6bf2850e43d81c9bade3db80c45837588956a1ad531594da"
    sha256 cellar: :any,                 big_sur:        "79f59b6cb8fef6f614c3b6f33558d7aa8202a3e7fad97e987e4b2094eaa71ece"
    sha256 cellar: :any,                 catalina:       "b82fd92f27a1b71327f51240cc1427d77228bceaf774bbad36d5efb0b1b6c0dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dffc9eb58a90565d7e148b838e1d6d47159dc0aa2e86c36ededa46d1083be26c"
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
