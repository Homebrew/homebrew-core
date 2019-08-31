class Readline < Formula
  desc "Library for command-line editing"
  homepage "https://tiswww.case.edu/php/chet/readline/rltop.html"
  url "https://ftp.gnu.org/gnu/readline/readline-8.0.tar.gz"
  mirror "https://ftpmirror.gnu.org/readline/readline-8.0.tar.gz"
  version "8.0.1"
  sha256 "e339f51971478d369f8a053a330a190781acb9864cf4c541060f12078948e461"

  %w[
    001 d8e5e98933cf5756f862243c0601cb69d3667bb33f2c7b751fe4e40b2c3fd069
  ].each_slice(2) do |p, checksum|
    patch :p0 do
      url "https://ftp.gnu.org/gnu/readline/readline-8.0-patches/readline80-#{p}"
      mirror "https://ftpmirror.gnu.org/readline/readline-8.0-patches/readline80-#{p}"
      sha256 checksum
    end
  end

  bottle do
    cellar :any
    sha256 "faab004773e6449dd97971311cb62a9bbaa44f1483b82640e818f0c355c8266d" => :mojave
    sha256 "7a45c1ed8488b6832f067adffaab328d643090d118f722f59ce4651731e10f1c" => :high_sierra
    sha256 "84edf47dae849438e675ef98910e08b3176de9e2abbad83e50e88d4111c6557e" => :sierra
  end

  keg_only :shadowed_by_macos, <<~EOS
    macOS provides the BSD libedit library, which shadows libreadline.
    In order to prevent conflicts when programs look for libreadline we are
    defaulting this GNU Readline installation to keg-only
  EOS

  def install
    system "./configure", "--prefix=#{prefix}"
    # There is no termcap.pc in the base system, so we have to comment out
    # the corresponding Requires.private line otherwise pkg-config will
    # consider the readline module unusable
    inreplace "readline.pc", /^(Requires.private: .*)$/, "# \\1"
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
