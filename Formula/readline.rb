class Readline < Formula
  desc "Library for command-line editing"
  homepage "https://tiswww.case.edu/php/chet/readline/rltop.html"
  url "https://ftpmirror.gnu.org/readline/readline-7.0.tar.gz"
  mirror "https://ftp.gnu.org/gnu/readline/readline-7.0.tar.gz"
  sha256 "750d437185286f40a369e1e4f4764eda932b9459b5ec9a731628393dd3d32334"

  bottle do
    cellar :any
    sha256 "11f2ad09f5eb9e055b2567c4308f35cc8e006b9ffdfe49599e4c4d92a0a3a066" => :sierra
    sha256 "9d38481c935cef21ead25c294285b78a9e8fa556fd15ede9126926c055c40d37" => :el_capitan
    sha256 "d0cdb3e162c05e21c7184e86629f04685d4be98e38cbf024373142bf8764500e" => :yosemite
    sha256 "adcc6352d3fb271a1e9ce034d80996405a5c46afbd1bab1507d3ff5e89e02bc1" => :mavericks
    sha256 "6b1d7e806e169e2b778371d74e7cc62106c348ea9f5c80fd658b763b94dc748e" => :mountain_lion
    sha256 "c129333634dd00ab2267ae9c531fca1f5cc50dd519ed3399918289fdfdf2663b" => :lion
  end

  keg_only :shadowed_by_osx, <<-EOS.undent
    OS X provides the BSD libedit library, which shadows libreadline.
    In order to prevent conflicts when programs look for libreadline we are
    defaulting this GNU Readline installation to keg-only.
  EOS

  def install
    ENV.universal_binary
    system "./configure", "--prefix=#{prefix}", "--enable-multibyte"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <stdio.h>
      #include <stdlib.h>
      #include <readline/readline.h>

      int main()
      {
        printf("%s\\n", readline("test> "));
        return 0;
      }
    EOS
    system ENV.cc, "-L", lib, "test.c", "-lreadline", "-o", "test"
    assert_equal "test> Hello, World!\nHello, World!",
      pipe_output("./test", "Hello, World!\n").strip
  end
end
