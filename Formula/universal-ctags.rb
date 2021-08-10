class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p5.9.20210801.0.tar.gz"
  version "p5.9.20210801.0"
  sha256 "779248492b86bb8bfaf0b12f4e53c5032e9324f70542378c8863ef5bac2770bf"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "bbb9c2c7f000943417698890413e5e27ae47278b8fa3a78356ba69d6a282e77a"
    sha256 cellar: :any,                 big_sur:       "73de142ba12e183df82bcc1021c2f72df55ffa14cfb6eeca8437773a84cc8794"
    sha256 cellar: :any,                 catalina:      "9e963df4bfc0f1150e1ffa8b56c9615888cacbfe88190aa5cf6fbec88f5f89cf"
    sha256 cellar: :any,                 mojave:        "3357ab44cedf0448b2deabff900e1e133cb998e3d48f85ef72a213fb57fec3ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25f45d1fc938be7f20fe11e53e2d418666bc714f5433ae6b01cfcf305ba7e25d"
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
