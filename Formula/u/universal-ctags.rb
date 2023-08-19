class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p6.0.20230813.0.tar.gz"
  version "p6.0.20230813.0"
  sha256 "10fd1f3eeab7b4d3b2d43c21870e2a2d8fbe5e9f9cdabb881d3081a6176665e1"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee3063c8bf7ef605ee44afcf976c7c01fbb9224a1cf491e8ccd1b6002de100c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1de60e25503945be749d2f6507cf834d265eaee42a91dbc97f0f861418e0145c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f49ca03e50b566ba9588803729cd94e26c81e1a23c9dab18760e0774bdd34670"
    sha256 cellar: :any_skip_relocation, ventura:        "9720e93739d29b13a50e4ebf81f0b6177d8b01088c4d2dc448b6c8ecd0c84bc4"
    sha256 cellar: :any_skip_relocation, monterey:       "babc956d2e579497a8cdbad9571ee66d66b8abadd97126c37eea31adec5c20cd"
    sha256 cellar: :any_skip_relocation, big_sur:        "6b2972f0ce7373493bfa2038024c44e4e9b493ae6c40d83964264288d4c89158"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b3bd0a292a42ccbc8b2d4f86ee1528c0c22d2119bdbb6cec4e48b86450eeb7c"
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
