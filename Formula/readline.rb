class Readline < Formula
  desc "Library for command-line editing"
  homepage "https://tiswww.case.edu/php/chet/readline/rltop.html"
  url "https://ftp.gnu.org/gnu/readline/readline-7.0.tar.gz"
  mirror "https://ftpmirror.gnu.org/readline/readline-7.0.tar.gz"
  version "7.0.5"
  sha256 "750d437185286f40a369e1e4f4764eda932b9459b5ec9a731628393dd3d32334"

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

  %w[
    001 9ac1b3ac2ec7b1bf0709af047f2d7d2a34ccde353684e57c6b47ebca77d7a376
    002 8747c92c35d5db32eae99af66f17b384abaca961653e185677f9c9a571ed2d58
    003 9e43aa93378c7e9f7001d8174b1beb948deefa6799b6f581673f465b7d9d4780
    004 f925683429f20973c552bff6702c74c58c2a38ff6e5cf305a8e847119c5a6b64
    005 ca159c83706541c6bbe39129a33d63bbd76ac594303f67e4d35678711c51b753
  ].each_slice(2) do |p, checksum|
    patch :p0 do
      url "https://ftp.gnu.org/gnu/readline/readline-7.0-patches/readline70-#{p}"
      mirror "https://ftpmirror.gnu.org/readline/readline-7.0-patches/readline70-#{p}"
      sha256 checksum
    end
  end

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
