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
    sha256 "3c754391e9d243835811d128771ca0f1a565024100fd2c2871534353d46aaf0e" => :mojave
    sha256 "ae341a036139a92a47396aabc773ffcf40a17fc388aaadf0147f688c72ece987" => :high_sierra
    sha256 "f234d1ff8148bf08b0ac31e661f2e96b5c6e64df26a45d2392056c9077f964af" => :sierra
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
