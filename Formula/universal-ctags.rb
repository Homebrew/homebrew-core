class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p5.9.20211010.0.tar.gz"
  version "p5.9.20211010.0"
  sha256 "4a847b743629c71e9c4da3b7267cdba83e4a4891064ff33282e67f66360a567e"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "5f049678ddc0b73f24676911c0b172fab681034601bb3e2e13299a4346ea330a"
    sha256 cellar: :any,                 big_sur:       "3ad4d64921304a1c472cf7db20d5a0ef13f014cae35aece134a1269f24a8c763"
    sha256 cellar: :any,                 catalina:      "e125e1646e098a76858d0d418ad551742e5f956a5e940a631859c2fa0405ebde"
    sha256 cellar: :any,                 mojave:        "448004ead41860d58355728b31dda514ace223b40e52c7f0101f93c068fc3a5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1cb957019e1b92b93193b316c7db2bf94b39a6cee5994235260c824040e9d2ba"
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
