class X8664ElfBinutils < Formula
  desc "GNU Binutils for x86_64-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.35.tar.gz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.35.tar.gz"
  sha256 "a3ac62bae4f339855b5449cfa9b49df90c635adbd67ecb8a0e7f3ae86a058da6"

  bottle do
    sha256 "4aa6103fb091ca890f96fc4bd32ede47ea00180190ce7af74c3ef6d2a33efd01" => :catalina
    sha256 "3fbbd0397080012c98d274499dcaf3ca6c510f9d18adc9040d725ec82c7ab31c" => :mojave
    sha256 "000600460decf639019762f1eafaf6c353b6974b2bca17a42786361014aff54e" => :high_sierra
  end

  def install
    system "./configure", "--target=x86_64-elf",
                          "--prefix=#{prefix}",
                          "--infodir=#{info}/x86_64-elf-binutils",
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
