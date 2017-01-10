class Readline < Formula
  desc "Library for command-line editing"
  homepage "https://tiswww.case.edu/php/chet/readline/rltop.html"
  url "https://ftpmirror.gnu.org/readline/readline-7.0.tar.gz"
  mirror "https://ftp.gnu.org/gnu/readline/readline-7.0.tar.gz"
  version "7.0.1"
  sha256 "750d437185286f40a369e1e4f4764eda932b9459b5ec9a731628393dd3d32334"

  bottle do
    cellar :any
    sha256 "57f11a1e678f3aab637f45dfe4178e440553a77c744c08ebf446a91341129a95" => :sierra
    sha256 "e3e5f24328fc3ff54217b4d75c63a0ef258ef1143d910feab4af9b3300598603" => :el_capitan
    sha256 "5eeccaa91566f0eb1301c0592e64414d35b1334d9c3ea77cbd916fef487ee1cb" => :yosemite
  end

  patch :p0 do
    url "https://ftpmirror.gnu.org/readline/readline-7.0-patches/readline70-001"
    mirror "https://ftp.gnu.org/gnu/readline/readline-7.0-patches/readline70-001"
    sha256 "9ac1b3ac2ec7b1bf0709af047f2d7d2a34ccde353684e57c6b47ebca77d7a376"
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
