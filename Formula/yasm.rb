class Yasm < Formula
  desc "Modular BSD reimplementation of NASM"
  homepage "https://yasm.tortall.net/"
  url "https://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz"
  mirror "https://ftp.openbsd.org/pub/OpenBSD/distfiles/yasm-1.3.0.tar.gz"
  sha256 "3dce6601b495f5b3d45b59f7d2492a340ee7e84b5beca17e48f862502bd5603f"
  revision 2

  bottle do
    cellar :any_skip_relocation
    sha256 "a3b57d242cdd13967472fbb5badd774d677428b6f730438d18fd153920dd3620" => :mojave
    sha256 "aa12e2f4b22a402405553706681d5c6bde592a1958a7c1e2594a365c29834625" => :high_sierra
    sha256 "49aa187cc261f03269c7036f1c39d6ff58d6748a25b247a0c51f8f3ecbf032cd" => :sierra
  end

  head do
    url "https://github.com/yasm/yasm.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext"
  end

  def install
    args = %W[
      --disable-debug
      --prefix=#{prefix}
      --disable-python
    ]

    # https://github.com/Homebrew/legacy-homebrew/pull/19593
    ENV.deparallelize

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.asm").write <<~EOS
      global start
      section .text
      start:
          mov     rax, 0x2000004 ; write
          mov     rdi, 1 ; stdout
          mov     rsi, qword msg
          mov     rdx, msg.len
          syscall
          mov     rax, 0x2000001 ; exit
          mov     rdi, 0
          syscall
      section .data
      msg:    db      "Hello, world!", 10
      .len:   equ     $ - msg
    EOS
    system "#{bin}/yasm", "-f", "macho64", "test.asm"
    system "/usr/bin/ld", "-macosx_version_min", "10.7.0", "-lSystem", "-o", "test", "test.o"
    system "./test"
  end
end
