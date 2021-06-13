class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p5.9.20210613.0.tar.gz"
  version "p5.9.20210613.0"
  sha256 "74c9e515f0cb71d92b4422392effba21794b11fc34f0971aa4dc44e9a86708f4"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "22ecb44c46403ed49a321cbb353be57701f407d6ae1e1e6c146b54d17d54d0c8"
    sha256 cellar: :any, big_sur:       "810b33bf6a56b7ed0886fdb05762d4ebfdefd8e746e64cb8261e8afc3e034a83"
    sha256 cellar: :any, catalina:      "2ed2032671b9e8d7515beb2bd4bcd2ad2df103ac96fe8859266b78c2900f8d42"
    sha256 cellar: :any, mojave:        "da478d18209f8f9a31f405d2d89f17cda748748940d8c9480e8a00338536c64a"
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
