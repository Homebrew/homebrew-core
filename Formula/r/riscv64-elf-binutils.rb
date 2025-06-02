class Riscv64ElfBinutils < Formula
  desc "GNU Binutils for riscv64-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.44.tar.bz2"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.44.tar.bz2"
  sha256 "f66390a661faa117d00fab2e79cf2dc9d097b42cc296bf3f8677d1e7b452dc3a"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_sequoia: "f472f7fe69981f7d860f6f0e6e1bc78e6639226f8bc2f4e7744a9f177b079ce9"
    sha256 arm64_sonoma:  "c46cd7e69e1749187f014b0fbf1668c191a0424b7fd6a95c24bb2c392a0e66f7"
    sha256 arm64_ventura: "cd10f00638540334c0a1c6f2f8af13360c1052075fe86489dbcbbf8407eb2eae"
    sha256 sonoma:        "13e059cd58a16e9b125a221b4cbe20821a52adbce5de9bb7b446de84030fb4bc"
    sha256 ventura:       "22a588a8a73828bdcd18a02acb9cb957264ffd69c23e1385d49ced61f5ef20ab"
    sha256 arm64_linux:   "4b776625620fb882bcfe1abd418e8e7af15a8bf61f3126c735fd8f0aa37b40b4"
    sha256 x86_64_linux:  "fbe2bc02087b1a79587039dccd73b023b597232412d3b6855c845f3f69d872ae"
  end

  depends_on "pkgconf" => :build
  depends_on "zstd"

  uses_from_macos "zlib"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
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
