class Yasm < Formula
  desc "Modular BSD reimplementation of NASM"
  homepage "https://yasm.tortall.net/"
  url "https://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz"
  mirror "https://ftp.openbsd.org/pub/OpenBSD/distfiles/yasm-1.3.0.tar.gz"
  sha256 "3dce6601b495f5b3d45b59f7d2492a340ee7e84b5beca17e48f862502bd5603f"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d1a844ce9a26db6d2a5c72dbced52b7fbfc8491bfde95a2f026eaa1e46433be"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "398b7f3d8a22e43b5af2335fe2d39448a3e9cc7a769ef1faf60c25fda0873d50"
    sha256 cellar: :any_skip_relocation, monterey:       "8348a13c38c499aa114f71e4d46f311105b68dbafbf0e92f6c19d5b492eed569"
    sha256 cellar: :any_skip_relocation, big_sur:        "ca95cb3c02508796ff4e60d54146b03016b93e80837916359912ebf737a37562"
    sha256 cellar: :any_skip_relocation, catalina:       "9aa61930f25fe305dc5364e72f539b0a225702b5f1dc222a9dde1216e901f7ab"
    sha256 cellar: :any_skip_relocation, mojave:         "0dc797b72ee3bad9c6a52276c871ac745207b5626722e805fa642d7a872847fc"
    sha256 cellar: :any_skip_relocation, high_sierra:    "7f31deeff91c5929f2cd52eca6b636669f9c8966f6d4777e89fa4b04e541ad85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6d46adb6213bba936b7d62ef9564f752cc5b4268e19e91f0b67e136408ab30e"
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
    (testpath/"foo.s").write <<~EOS
      mov eax, 0
      mov ebx, 0
      int 0x80
    EOS
    system "#{bin}/yasm", "foo.s"
    code = File.open("foo", "rb") { |f| f.read.unpack("C*") }
    expected = [0x66, 0xb8, 0x00, 0x00, 0x00, 0x00, 0x66, 0xbb,
                0x00, 0x00, 0x00, 0x00, 0xcd, 0x80]
    assert_equal expected, code

    if OS.mac?
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
      system "/usr/bin/ld", "-macosx_version_min", "10.8.0", "-static", "-o", "test", "test.o"
    else
      (testpath/"test.asm").write <<~EOS
        global _start
        section .text
        _start:
            mov     rax, 1
            mov     rdi, 1
            mov     rsi, msg
            mov     rdx, msg.len
            syscall
            mov     rax, 60
            mov     rdi, 0
            syscall
        section .data
        msg:    db      "Hello, world!", 10
        .len:   equ     $ - msg
      EOS
      system "#{bin}/yasm", "-f", "elf64", "test.asm"
      system "/usr/bin/ld", "-static", "-o", "test", "test.o"
    end
    assert_equal "Hello, world!\n", shell_output("./test")
  end
end
