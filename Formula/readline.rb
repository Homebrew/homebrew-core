class Readline < Formula
  desc "Library for command-line editing"
  homepage "https://tiswww.case.edu/php/chet/readline/rltop.html"
  url "https://ftpmirror.gnu.org/readline/readline-7.0.tar.gz"
  mirror "https://ftp.gnu.org/gnu/readline/readline-7.0.tar.gz"
  version "7.0.3"
  sha256 "750d437185286f40a369e1e4f4764eda932b9459b5ec9a731628393dd3d32334"

  bottle do
    cellar :any
    sha256 "deec35341dcf2641cc8a64f7f4d01b124c456ee1675a4d6618638f220bc01b26" => :sierra
    sha256 "eee9dd140f1a7f7266279e2f900a9da49909b46755cd8941c506962be2608d02" => :el_capitan
    sha256 "443c8429e82f5a32e070d81b584ceae1844e07277488ca1457eccee6fb1a7114" => :yosemite
  end

  %w[
    001 9ac1b3ac2ec7b1bf0709af047f2d7d2a34ccde353684e57c6b47ebca77d7a376
    002 8747c92c35d5db32eae99af66f17b384abaca961653e185677f9c9a571ed2d58
    003 9e43aa93378c7e9f7001d8174b1beb948deefa6799b6f581673f465b7d9d4780
  ].each_slice(2) do |p, checksum|
    patch :p0 do
      url "https://ftpmirror.gnu.org/readline/readline-7.0-patches/readline70-#{p}"
      mirror "https://ftp.gnu.org/gnu/readline/readline-7.0-patches/readline70-#{p}"
      sha256 checksum
    end
  end

  keg_only :shadowed_by_osx, <<-EOS.undent
    macOS provides the BSD libedit library, which shadows libreadline.
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
