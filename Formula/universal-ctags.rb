class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p5.9.20210725.0.tar.gz"
  version "p5.9.20210725.0"
  sha256 "0af8cbda189bea26ff576c6477935ae1bca240c8547acd7a9ff388424cd43d9e"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "9ff4b3e0eb16ab0899b899cf835b0dc9a537f29616831b135ce13b76d1a6a769"
    sha256 cellar: :any,                 big_sur:       "6916c96a4cc8ddcc226750edac2193cc01c5c32012bbd0dd49ef99c11c537909"
    sha256 cellar: :any,                 catalina:      "ad7e7d6be8182f77c57677b8599bd5cb6b6ab33e7ec05a17bad185ea4b379ba1"
    sha256 cellar: :any,                 mojave:        "09329630ec33c4811995d04f22b27951bb860f3717ffbcfbd238550ed4e19462"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e54a50e7f51752f62b8cd076d7d5d335bdc06bc96be222a68615974972df63d4"
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
