class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://ctags.io/"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p6.1.20250420.0.tar.gz"
  version "p6.1.20250420.0"
  sha256 "4ceec00e01fcae9c80f674ce622e6082e0626c935041247d6a1f049769bb54ef"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ff55abc5918caa9a180e492288ed0aee915f2d935e1b8076fb85c1fa9942f553"
    sha256 cellar: :any,                 arm64_sonoma:  "1a6c0a8d3d560c0a20946f97dbf34e867f6d44c9bcac6e920986d50630054925"
    sha256 cellar: :any,                 arm64_ventura: "512b7f47e840f4ab1d870ad5de7e413dcb2e9c05383f45ed619ae5fdc5f4f5eb"
    sha256 cellar: :any,                 sonoma:        "2cfd36d1c52a00d19031c9d3c86e9ead08a276b2afadf7bb1d3a8607ab5d6bbd"
    sha256 cellar: :any,                 ventura:       "be5bf97d629ace6307589ea83be543c959de72c4123583a7b0ef1a1750a3bcd9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28ff7b8a0adf0d3cfbab48b15b2b640caabbcb24238644b977384501aeaa3c48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53794ee1c0f9ae8c524904e94ba55c32962822529ebdcd13e7ce9fb5f5f3bdb2"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "docutils" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
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
    (testpath/"test.c").write <<~C
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
    C
    system bin/"ctags", "-R", "."
    assert_match(/func.*test\.c/, File.read("tags"))
  end
end
