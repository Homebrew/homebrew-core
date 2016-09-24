class Yasm < Formula
  desc "Modular BSD reimplementation of NASM"
  homepage "http://yasm.tortall.net/"
  url "https://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz"
  sha256 "3dce6601b495f5b3d45b59f7d2492a340ee7e84b5beca17e48f862502bd5603f"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "64fcf11922e264c548239b9c4d146a99d5d3962284bd310d4ee3bf1bbad1f6db" => :sierra
    sha256 "7dc741b8006e58498622b846151270d1d958d9cff7d4dc2aade0cdad532639d5" => :el_capitan
    sha256 "5c5191c5a6b6c523334cdf43ff1af761f2fee1ee94111652a7f0dd369e9153e5" => :yosemite
    sha256 "734b4d3d218323417b7b5aa1edf2e47c4309e37207bcaf5f9e13da96aa6201d9" => :mavericks
  end

  head do
    url "https://github.com/yasm/yasm.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext"
  end

  depends_on :python => :optional

  resource "cython" do
    url "https://files.pythonhosted.org/packages/c6/fe/97319581905de40f1be7015a0ea1bd336a756f6249914b148a17eefa75dc/Cython-0.24.1.tar.gz"
    sha256 "84808fda00508757928e1feadcf41c9f78e9a9b7167b6649ab0933b76f75e7b9"
  end

  def install
    args = %W[
      --disable-debug
      --prefix=#{prefix}
    ]

    if build.with? "python"
      ENV.prepend_create_path "PYTHONPATH", buildpath+"lib/python2.7/site-packages"
      resource("cython").stage do
        system "python", "setup.py", "build", "install", "--prefix=#{buildpath}"
      end

      args << "--enable-python"
      args << "--enable-python-bindings"
    end

    # https://github.com/Homebrew/homebrew/pull/19593
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
