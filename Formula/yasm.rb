class Yasm < Formula
  desc "Modular BSD reimplementation of NASM"
  homepage "http://yasm.tortall.net/"
  url "https://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz"
  mirror "https://ftp.openbsd.org/pub/OpenBSD/distfiles/yasm-1.3.0.tar.gz"
  sha256 "3dce6601b495f5b3d45b59f7d2492a340ee7e84b5beca17e48f862502bd5603f"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "ddb536410f898cba342c9c2d01696a690a28a4f1e9e30c67a3e352a41791fc85" => :high_sierra
    sha256 "2ca19bb3f563569aa4eac4fd3398a7eb14a7fb1268b4ffe86ad7980f9701d1b7" => :sierra
    sha256 "0dd9ef773dfbf9c59ab13c1fb7ec616d1ffba1c240357497d75482e0743c4119" => :el_capitan
    sha256 "fc205e75319ba9e63a2e5fa6beccc66a163325a3a4a51807a2cf1844512f2c24" => :yosemite
  end

  head do
    url "https://github.com/yasm/yasm.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext"
  end

  depends_on "cython" => :build

  def install
    args = %W[
      --disable-debug
      --prefix=#{prefix}
    ]

    ENV.prepend_path "PYTHONPATH", Formula["cython"].opt_libexec/"lib/python2.7/site-packages"
    args << "--enable-python"
    args << "--enable-python-bindings"

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
