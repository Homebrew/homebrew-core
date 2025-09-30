class Riscv64ElfBinutils < Formula
  desc "GNU Binutils for riscv64-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftpmirror.gnu.org/gnu/binutils/binutils-2.45.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.45.tar.bz2"
  sha256 "1393f90db70c2ebd785fb434d6127f8888c559d5eeb9c006c354b203bab3473e"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_tahoe:   "da7fae36915c1ac01f02e691f9a287527aa5ce3e2db9f7cef473eba677de13f2"
    sha256 arm64_sequoia: "ac4ff8f1f9f3b05440919bb1cbfff9c1025013663e11dccc1d1eed0a7d6a6e4c"
    sha256 arm64_sonoma:  "47a482f6bea910cfda833737f5aa218534532efb513d7d22a79ae63e4fd62033"
    sha256 arm64_ventura: "86e3e5b2804c55afcbc1f1a09f5e5ff336ca6b79b7765c3366179964a594a96a"
    sha256 sonoma:        "f1fbfd5cd6528ea5f007e5beb3400e020ea1f3b4df13626e041e189634a5c88e"
    sha256 ventura:       "c0b867a28be94bc2b9d946d3be7418e0d4e45535a69a14081a99639e5e36ac1d"
    sha256 arm64_linux:   "2bb7cbef82cb462e8f9a906f32488891e82e5364faff358711ba6a88dee87eed"
    sha256 x86_64_linux:  "400f96cdf61503cc9dc3bb3dc9e7951889941312cea67ce62a8650343bb6d52a"
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
