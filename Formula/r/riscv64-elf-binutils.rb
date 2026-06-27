class Riscv64ElfBinutils < Formula
  desc "GNU Binutils for riscv64-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftpmirror.gnu.org/gnu/binutils/binutils-2.46.1.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.46.1.tar.bz2"
  sha256 "324ed40ada2633a28eaa5d104ca5db165fd3cc3162cc1d48a7b7fa9c932da439"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_tahoe:   "5ee6eb0665bd0525d40efa737c185534b02f7deb5220d440ce4ae389da99ab3d"
    sha256 arm64_sequoia: "332bd6874b5b3c9fc61460d41fa42468e337b2c62d02d0a94620e7f6729954be"
    sha256 arm64_sonoma:  "9e6b722f7ebdd69d457400d86ff76db7c72d309c6faf242dceed716d6350bc43"
    sha256 sonoma:        "24e863841187b9cec87418c3b4ced7f6dbeec65e4fa6aa1c9467534b04555a11"
    sha256 arm64_linux:   "dac35ea1b255bd8e3f687242f161a6593af957ba07351c238df19b1f31c9ecad"
    sha256 x86_64_linux:  "bed24bd67f83ada6f1cf0752ada65015bef3b28aefee16f169d8506393313e91"
  end

  depends_on "pkgconf" => :build
  depends_on "zstd"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    target = "riscv64-elf"
    system "./configure", "--target=#{target}",
                          "--prefix=#{prefix}",
                          "--libdir=#{lib}/#{target}",
                          "--infodir=#{info}/#{target}",
                          "--with-system-zlib",
                          "--with-zstd",
                          "--disable-nls"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test-s.s").write <<~ASM
      .section .text
      .globl _start
      _start:
          li a7, 93
          li a0, 0
          ecall
    ASM

    system bin/"riscv64-elf-as", "-o", "test-s.o", "test-s.s"
    assert_match "file format elf64-littleriscv",
                 shell_output("#{bin}/riscv64-elf-objdump -a test-s.o")
    assert_match "f()", shell_output("#{bin}/riscv64-elf-c++filt _Z1fv")
  end
end
