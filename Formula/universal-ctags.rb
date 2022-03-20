class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p5.9.20220320.0.tar.gz"
  version "p5.9.20220320.0"
  sha256 "9a8a9b0e993571c69a101d0729da4af4a53225877d933f078768cbedda2d933f"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c66f5de3b2940c47eeab17aa0b79544e5b53a6635658e849bccbee52dd4afe28"
    sha256 cellar: :any,                 arm64_big_sur:  "a227c546680d79f10df169232467cecff3f240f8b9bedb013e2b02eee5205238"
    sha256 cellar: :any,                 monterey:       "b3fc36cdec236336180c3cd61b737beb4de060ee8090b2365dc244bbe753a63c"
    sha256 cellar: :any,                 big_sur:        "d4f2c88672fc4ac275c18ed1d6dceadcbc725cbeb6522f84cba67ed32b614083"
    sha256 cellar: :any,                 catalina:       "616e525d472c479fb3c19884619d1054ea13cee9046b557955195d1e5bcf7c37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a5f02ea3a16399337534c5bc8536f1f1b8c639e05094c72af3ec7f6c2b3b44b"
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
