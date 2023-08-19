class Riscv64ElfBinutils < Formula
  desc "GNU Binutils for riscv64-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.41.tar.bz2"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.41.tar.bz2"
  sha256 "a4c4bec052f7b8370024e60389e194377f3f48b56618418ea51067f67aaab30b"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_ventura:  "c59f26200d456bbd07db59f135022b70091c63371e1c2e226214d9f93360a0e0"
    sha256 arm64_monterey: "46abb8516dfcb932674393cca78daf2955837107bcba201d04cc72ea67a45a2a"
    sha256 arm64_big_sur:  "b2b1f2af66610808bb3f4ae7dc35af0cf481e4abc628978484aee46d05ec2a6f"
    sha256 ventura:        "4e81af5df43f4c526c016cf8a0ad5c8bf12b0671de0cae92fcbfd13fcab902ec"
    sha256 monterey:       "a4f00ab31c414f29c7c10c2c746620936723717591e9a5233f4551425634aee3"
    sha256 big_sur:        "24d0e9c0484475aa945c8556fc532f8650ded78bdc635345286466c10f929080"
    sha256 x86_64_linux:   "109c9c6ed53f1c45d3ce11a21219f985cfb681b7b2af95ab590d12f34f7cfd21"
  end

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    target = "riscv64-elf"
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
      .section .text
      .globl _start
      _start:
          li a7, 93
          li a0, 0
          ecall
    EOS
    system "#{bin}/riscv64-elf-as", "-o", "test-s.o", "test-s.s"
    assert_match "file format elf64-littleriscv",
                 shell_output("#{bin}/riscv64-elf-objdump -a test-s.o")
    assert_match "f()", shell_output("#{bin}/riscv64-elf-c++filt _Z1fv")
  end
end
