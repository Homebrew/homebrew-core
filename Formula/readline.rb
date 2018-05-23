class Readline < Formula
  desc "Library for command-line editing"
  homepage "https://tiswww.case.edu/php/chet/readline/rltop.html"
  revision 1

  stable do
    url "https://ftp.gnu.org/gnu/readline/readline-7.0.tar.gz"
    mirror "https://ftpmirror.gnu.org/readline/readline-7.0.tar.gz"
    version "7.0.3"
    sha256 "750d437185286f40a369e1e4f4764eda932b9459b5ec9a731628393dd3d32334"

    %w[
      001 9ac1b3ac2ec7b1bf0709af047f2d7d2a34ccde353684e57c6b47ebca77d7a376
      002 8747c92c35d5db32eae99af66f17b384abaca961653e185677f9c9a571ed2d58
      003 9e43aa93378c7e9f7001d8174b1beb948deefa6799b6f581673f465b7d9d4780
    ].each_slice(2) do |p, checksum|
      patch :p0 do
        url "https://ftp.gnu.org/gnu/readline/readline-7.0-patches/readline70-#{p}"
        mirror "https://ftpmirror.gnu.org/readline/readline-7.0-patches/readline70-#{p}"
        sha256 checksum
      end
    end
  end

  bottle do
    cellar :any
    sha256 "45322d69fba127fe9d5c8d1d2fe8b57e0a657b0ebc0a8143cc47118243828dfd" => :high_sierra
    sha256 "af7886c963fe3e9f58c45d679a64b278f4df7b172bbd978cf42658a7fd7b4a2a" => :sierra
    sha256 "86766a343a07e08c52e7e87e64a12d3aa34bf71ba248fc779a2c5b0664797ba9" => :el_capitan
    sha256 "11589e87c4860e414fe5a4b3481d20e47258f41a91a7490a5c88e1a57d5e1d18" => :yosemite
  end

  devel do
    url "https://ftp.gnu.org/gnu/readline/readline-8.0-alpha.tar.gz"
    mirror "https://ftpmirror.gnu.org/readline/readline-8.0-alpha.tar.gz"
    sha256 "81d975b3687c6dea260baf1754009ef24c4b2b851f35e0bef4c06be7524cbfba"

    # Fix "lib/pkgconfig/readline.pc: No such file or directory"
    # Reported 23 May 2018 https://lists.gnu.org/archive/html/bug-readline/2018-05/msg00007.html
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/ae60828/readline/pkgconfigdir.patch"
      sha256 "aa5d014cc0cdef7a231c116764e8cf85ba77d5fcc5f9e7aec8df9dce76a864ed"
    end
  end

  keg_only :shadowed_by_macos, <<~EOS
    macOS provides the BSD libedit library, which shadows libreadline.
    In order to prevent conflicts when programs look for libreadline we are
    defaulting this GNU Readline installation to keg-only.
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
