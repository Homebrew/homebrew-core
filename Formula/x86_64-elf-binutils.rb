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
    sha256 "46f97c695943a5b35baffa5e06a372b9cf0c410799503b27610e7d17f13146eb" => :big_sur
    sha256 "f98f3c65ee6d746e1f3d00fccf58eb6c224d4f981ebe2731aa6ec68d28b28828" => :arm64_big_sur
    sha256 "2c3de0514d336239cf149fd1b7d1045fb90e9f351d04040162f96d4eb24bf567" => :catalina
    sha256 "9f79d95eae16f5907bb6414f0e10c69161cc095f379b0497114c943c454594d2" => :mojave
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
