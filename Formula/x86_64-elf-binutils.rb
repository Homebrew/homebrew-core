class X8664ElfBinutils < Formula
  desc "FSF Binutils for x86_64-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.34.tar.gz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.34.tar.gz"
  sha256 "53537d334820be13eeb8acb326d01c7c81418772d626715c7ae927a7d401cab3"

  bottle do
    sha256 "57141264369389b9c50019aac6bb0f6dcf19935f20ea8fab57b56d4c4451066a" => :catalina
    sha256 "2fa4917e60d82c29d70b90a5a725ecb26a29aa5cf148af16e73af045ee431c59" => :mojave
    sha256 "ed28927581eb4e2a8bfd10134eec40e1b1055161a5fb26580453943fb3bffe72" => :high_sierra
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
    assert_match "file format elf64-x86-64",
      shell_output("#{Formula["x86_64-elf-binutils"].bin}/x86_64-elf-objdump -a test-s.o")
  end
end
