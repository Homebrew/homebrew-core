class X8664ElfBinutils < Formula
  desc "FSF Binutils for x86_64-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.33.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.33.1.tar.gz"
  sha256 "98aba5f673280451a09df3a8d8eddb3aa0c505ac183f1e2f9d00c67aa04c6f7d"

  def install
    system "./configure", "--target=x86_64-elf",
                          "--enable-targets=all",
                          "--enable-multilib",
                          "--enable-64-bit-bfd",
                          "--disable-werror",
                          "--prefix=#{prefix}"
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
    assert_match "file format elf64-x86-64", shell_output("#{Formula["x86_64-elf-binutils"].bin}/x86_64-elf-objdump -a test-s.o")
  end
end
