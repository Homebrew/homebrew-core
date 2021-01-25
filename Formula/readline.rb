class Readline < Formula
  desc "Library for command-line editing"
  homepage "https://tiswww.case.edu/php/chet/readline/rltop.html"
  url "https://ftp.gnu.org/gnu/readline/readline-8.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/readline/readline-8.1.tar.gz"
  sha256 "f8ceb4ee131e3232226a17f51b164afc46cd0b9e6cef344be87c65962cb82b02"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/href=.*?readline[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "2cc3a9582e3c7e21eb3c2c8964abd33e9720fb4a9588c626d8424ff8cc9b1aed" => :big_sur
    sha256 "940e7c2b80ef7f59b26726a5669a31fcb8ba7cbbb17eb1f2ca589dafa6e68e5e" => :arm64_big_sur
    sha256 "fe4de019cf549376a7743dcb0c86db8a08ca2b6d0dd2f8cb796dd7cf973dc2e9" => :catalina
    sha256 "1ea5a8050482911b319dc3e1436ee03310ba79d75d855d40114ba6067e01b9c5" => :mojave
  end

  keg_only :shadowed_by_macos, "macOS provides BSD libedit"

  uses_from_macos "ncurses"

  def install
    args = ["--prefix=#{prefix}"]
    on_linux do
      args << "--with-curses"
    end
    system "./configure", *args

    args = []
    on_linux do
      args << "SHLIB_LIBS=-lcurses"
    end
    # There is no termcap.pc in the base system, so we have to comment out
    # the corresponding Requires.private line.
    # Otherwise, pkg-config will consider the readline module unusable.
    inreplace "readline.pc", /^(Requires.private: .*)$/, "# \\1"
    system "make", "install", *args
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
