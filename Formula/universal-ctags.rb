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
    sha256 cellar: :any, arm64_big_sur: "92d4d99f7a290710eed8b4daf9026f9b0334ecf3e11950b33f05badd976ff32c"
    sha256 cellar: :any, big_sur:       "6878ce348f6416c549935681c1eceeac81d5e0953bdacabed8119677e58e3cb7"
    sha256 cellar: :any, catalina:      "9998b6ac03c9f591ced2c87ce488edb2796c67c00a7cd22516b993df7ae793c4"
    sha256 cellar: :any, mojave:        "d90f3b42e74eab21847cf460060f337aa98e0f8eed03469da8c12e92150f2c71"
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
