class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p6.1.20240609.0.tar.gz"
  version "p6.1.20240609.0"
  sha256 "aebba13d7cf7fb12aaadd8a942d23081c362394228f035f4884f52f921ee8e0f"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2d312a16ea057d2159132f502beaee70fb9229adab273fa204825f43a7f5f26e"
    sha256 cellar: :any,                 arm64_ventura:  "50b59f0840949c071b2040dc5dc0fc506f7589ac638af72b5758d3e2939e6bf1"
    sha256 cellar: :any,                 arm64_monterey: "b6774c9603e792e358ba2bc1ecf8375acb17259c4763d02b4f18165bdc504b4e"
    sha256 cellar: :any,                 sonoma:         "87a1872c8010dcb64b4ad4318a93388c0d53214c0aeff52df7dc531efc65cc0c"
    sha256 cellar: :any,                 ventura:        "5c8bfd6383b2df1def87fc477b96725ce812be7eb4875e2990b9875ce83b389e"
    sha256 cellar: :any,                 monterey:       "7bfe22b8190975bb88deaaf7538aa9895b6856475571464acdb42d21a12bfeb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "172bda560cb64b770bbd979456b9e7cd3aa60905138d44c1673019c69e2b21ac"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "docutils" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build
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
