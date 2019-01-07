class Readline < Formula
  desc "Library for command-line editing"
  homepage "https://tiswww.case.edu/php/chet/readline/rltop.html"
  url "https://ftp.gnu.org/gnu/readline/readline-8.0.tar.gz"
  mirror "https://ftpmirror.gnu.org/readline/readline-8.0.tar.gz"
  version "8.0.0"
  sha256 "e339f51971478d369f8a053a330a190781acb9864cf4c541060f12078948e461"

  bottle do
    cellar :any
    sha256 "5976a79f0dbd5ccb2a261f692763319d612309caa2b8cf703f209270764c657c" => :mojave
    sha256 "0cc8fcf8ee733e41c40b859a09eb00f723222a40398fdd15d32891df1eca2eef" => :high_sierra
    sha256 "962ae47be894e6d3a354b24953fc6b456c42dc054bcd44092cabf65e734a152b" => :sierra
    sha256 "a7f92cf74dfd299b0c368a983c6f83fc50395b0392b8465316133c625744bcc5" => :el_capitan
  end

  keg_only :shadowed_by_macos, <<~EOS
    macOS provides the BSD libedit library, which shadows libreadline.
    In order to prevent conflicts when programs look for libreadline we are
    defaulting this GNU Readline installation to keg-only
  EOS

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <stdlib.h>
      #include <readline/readline.h>

      int main()
      {
        printf("%s\\n", readline("test> "));
        return 0;
      }
    EOS
    system ENV.cc, "-L", lib, "test.c", "-L#{lib}", "-lreadline", "-o", "test"
    assert_equal "test> Hello, World!\nHello, World!",
      pipe_output("./test", "Hello, World!\n").strip
  end
end
