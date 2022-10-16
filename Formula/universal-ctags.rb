class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p5.9.20221016.0.tar.gz"
  version "p5.9.20221016.0"
  sha256 "5e331476fa8927a14704b9ebe429405940778b52bd04145a2ae183144096cbea"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "06be6b0e9bae9eba26a649d6f7dbee7f5381f4a646557e9b937aa0700e65a61d"
    sha256 cellar: :any,                 arm64_big_sur:  "a96317f96c1815c3b1df26f7f7c40e902c9a49161096c9140fb259a2d66ad6c9"
    sha256 cellar: :any,                 monterey:       "8c425251bd79a231b7405971877ef2f6c79eb5ad72ebb351289123b7193c29d4"
    sha256 cellar: :any,                 big_sur:        "174fb1784ea1868e099964b6772d6fa28f489faa950bb3c185e6529267726620"
    sha256 cellar: :any,                 catalina:       "600d7cd825e3096945f9687c717ab47aae19cf8bd76ec6df96749597e4b85109"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5aee8cff7b754bb446be9c8605511baec18fea2ee8cff9ae0ed7eb722bd706ec"
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
