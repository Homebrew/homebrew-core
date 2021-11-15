class X8664ElfBinutils < Formula
  desc "GNU Binutils for x86_64-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.37.tar.xz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.37.tar.xz"
  sha256 "820d9724f020a3e69cb337893a0b63c2db161dadcb0e06fc11dc29eb1e84a32c"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_monterey: "cc2b264def9baf925812bf75622f1132b16de47a940e4e999680ced6ce17580a"
    sha256 arm64_big_sur:  "c1cc0eeef6981f55e0df57f0e8115956ab5b4d94d043daf805c8833ed843dc1d"
    sha256 monterey:       "587fe762419c190b723e48506d6ea0a3ee571d0c0d479977c02225fdcba60393"
    sha256 big_sur:        "085e8d5b89905e85c00951d3f12a6b36ea2e085b07e6af28b4138956b9c53384"
    sha256 catalina:       "8853d7a257c9cbe3243e9cb48837222768b6a211c0a0b7733cd40effdb56cb72"
    sha256 mojave:         "efb90bb7f3e96087317c35a824fbe46e4dda1ccaaa6cd2fc26f889b6210b4d5a"
    sha256 x86_64_linux:   "94bb83f893103b9be998affaec0cc210691fa4b71c27d9491a7598c2c9a30576"
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
