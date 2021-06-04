class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p5.9.20210530.0.tar.gz"
  version "p5.9.20210530.0"
  sha256 "c332840e4a3c0c8cb28f9ff7b687a7762899d495b7dfc81bdf93c347cff018f7"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "48182f751f5f6efaa9516d4ed948e59b440b4e7fb0ad7b3ed654cbb7e2f4f44b"
    sha256 cellar: :any, big_sur:       "40e0a5ebd29473d1233c7e147e85ef84a01af9019c773816adb55a4fed9fd9d1"
    sha256 cellar: :any, catalina:      "a650abfb9ef8f9e33785c24a9230006db034b14e1dd4a4499a3a4ab56545534c"
    sha256 cellar: :any, mojave:        "867f69719f9325ce53746f57cca64cb6ea063001abcf53261d5591d848c308c6"
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
