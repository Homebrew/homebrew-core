class X8664ElfBinutils < Formula
  desc "GNU Binutils for x86_64-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.38.tar.xz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.38.tar.xz"
  sha256 "e316477a914f567eccc34d5d29785b8b0f5a10208d36bbacedcc39048ecfe024"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_monterey: "e2b52bc2a30d1f122cd507e6871b78f11184bdd3901bd2a63542b89cb7f92dd4"
    sha256 arm64_big_sur:  "2fcc7c012e83de82cfdcf2ec7e85422cebb1729a49e5cb0aeec067b9f0f9f204"
    sha256 monterey:       "565f5c0a2f5bdc98f05de4a67d0ea00d001d1d1eb2558dc42b61a0d434476c1e"
    sha256 big_sur:        "b4f920096a5671531df12d37641b6d1080a0fdcb670075a8a574fdfc16024e95"
    sha256 catalina:       "8ad3dc59de911df54f04db679b11e4fabc905dc4da3d01fb2a20ffa8532fdc34"
    sha256 x86_64_linux:   "b205d585e76879c684ab13f623d2c5d43f2f99e8383738d1d107f00227327e41"
  end

  uses_from_macos "texinfo"

  def install
    target = "x86_64-elf"
    system "./configure", "--target=#{target}",
                          "--enable-targets=x86_64-pep",
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
