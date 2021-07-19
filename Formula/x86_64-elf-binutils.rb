class X8664ElfBinutils < Formula
  desc "GNU Binutils for x86_64-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.37.tar.xz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.37.tar.xz"
  sha256 "820d9724f020a3e69cb337893a0b63c2db161dadcb0e06fc11dc29eb1e84a32c"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_big_sur: "2fdad9be777477e25e48f0f445c1ce0a751f41d8f12f011bb0f03b196e5da38c"
    sha256 big_sur:       "35bad9983b807b3dbbf640efad0e7e05651b3970cf03007b3e32213b8ee8332e"
    sha256 catalina:      "9770ee8f2705cb05cb9364097af357810756c128ca9ced34abbde2a98fbd0136"
    sha256 mojave:        "190ee3a8bc927c44be285a89df32bc889270a3169737d114ef97f2f1b4be9937"
    sha256 x86_64_linux:  "71068b026e8ccb1db4ac642d2d32e9db176f64c900cb13ece287fe8e2bd16e5e"
  end

  uses_from_macos "texinfo"

  def install
    target = "x86_64-elf"
    system "./configure", "--target=#{target}",
                          "--prefix=#{prefix}",
                          "--libdir=#{lib}/#{target}",
                          "--infodir=#{info}/#{target}",
                          "--disable-nls"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test-s.s").write <<~EOS
      .section .data
      .section .text
      .globl _start
      _start:
          movl $1, %eax
          movl $4, %ebx
          int $0x80
    EOS
    system "#{bin}/x86_64-elf-as", "--64", "-o", "test-s.o", "test-s.s"
    assert_match "file format elf64-x86-64",
      shell_output("#{bin}/x86_64-elf-objdump -a test-s.o")
  end
end
