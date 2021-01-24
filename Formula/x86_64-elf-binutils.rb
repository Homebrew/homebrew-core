class X8664ElfBinutils < Formula
  desc "GNU Binutils for x86_64-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.36.tar.gz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.36.tar.gz"
  sha256 "f67c632ccd81137d745681672bb4515a3411afa53722ccf01caa07d798fd8fb0"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "818e23ee2c82412584960a62bd921fc14b15266632089ef4427c1d8e66c65258" => :big_sur
    sha256 "a693bc568042d1f74f900428e99a716fe3192ae3c6bc4352601baef6c0ce0005" => :arm64_big_sur
    sha256 "8ca33c467a19a068f0e92c75d00f87115283072d5054672449d9abd2fa96036e" => :catalina
    sha256 "59d35da02f1387ae5fd0b0c13f1647a0ae7b88dcff3e662bb3eaa502990937c4" => :mojave
    sha256 "df62f4e6bf30c75023ebad89244e0a71d86f03966ba46892a5c1046332af2a73" => :high_sierra
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
