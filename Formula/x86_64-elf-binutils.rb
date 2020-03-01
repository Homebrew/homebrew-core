class X8664ElfBinutils < Formula
  desc "FSF Binutils for x86_64-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.34.tar.gz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.34.tar.gz"
  sha256 "53537d334820be13eeb8acb326d01c7c81418772d626715c7ae927a7d401cab3"

  bottle do
    sha256 "18ea6dbe526c6c14961968ab697cfa44852f99716c57df5ee1f4c80eeae4e44e" => :catalina
    sha256 "dc730e66867b76359b10193f959ed8c19cd28f5a84e702cc482a264b05909f7a" => :mojave
    sha256 "77187bb70a15356d0580f95fa37cbbe872d80afe569f4aa34aabf54ee5c71ee6" => :high_sierra
  end

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
