class Yasm < Formula
  desc "Modular BSD reimplementation of NASM"
  homepage "http://yasm.tortall.net/"
  url "https://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz"
  sha256 "3dce6601b495f5b3d45b59f7d2492a340ee7e84b5beca17e48f862502bd5603f"
  revision 1

  bottle do
    cellar :any_skip_relocation
    rebuild 3
    sha256 "6d43b79da083234769acfce5751fa0efc39d3ba4ccdd59890c5db73595138d8e" => :sierra
    sha256 "8c720d776fa0f622538b21b627b073cfc0fdf876676d2b4b93e774d8073f2db6" => :el_capitan
    sha256 "530150c2f57ca7ccd717b6edff43fc45a34edc8e92cd5ac16619f83710fe0d0e" => :yosemite
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
    (testpath/"test.asm").write <<-EOS.undent
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
