class X8664ElfBinutils < Formula
  desc "GNU Binutils for x86_64-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.36.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.36.1.tar.xz"
  sha256 "e81d9edf373f193af428a0f256674aea62a9d74dfe93f65192d4eae030b0f3b0"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_big_sur: "a5584ba07f4f488096061f8f11c5d2fad72b87f42526aae902ba24b2dded7e13"
    sha256 big_sur:       "98a1c41b67cda5c8552edf16e826aada8f29409da4477301db7ce861c6e93295"
    sha256 catalina:      "0911b52c58f70ea3fd24861c10f22b1f65a8f3ee08ec4c57f90a47cc19f529af"
    sha256 mojave:        "0b82544bb76a74993fa3a663b6ced46dd48e3f5afb61df97653cf46581f5c317"
  end

  uses_from_macos "texinfo"

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
