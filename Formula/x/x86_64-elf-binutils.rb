class X8664ElfBinutils < Formula
  desc "GNU Binutils for x86_64-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftpmirror.gnu.org/gnu/binutils/binutils-2.46.1.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.46.1.tar.bz2"
  sha256 "324ed40ada2633a28eaa5d104ca5db165fd3cc3162cc1d48a7b7fa9c932da439"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_tahoe:   "f7ccbea33fa29f1227bbc4546c4105cf18cf86c916312ddea585f03308b54599"
    sha256 arm64_sequoia: "52981373acf093df21c362302ede5724157a072ea719e123ff50fc528a832440"
    sha256 arm64_sonoma:  "e8430c6ed1d3fb4802670d268d603f8cb1c6c5af3022432d6e6a0023d2f2deca"
    sha256 sonoma:        "350ad92ba794fe8fa619b7496471efa948e76ed4d1a008b2f10b52432d04ce81"
    sha256 arm64_linux:   "c64d0c265d152ac4aa595cc94cfd2312def3338d1f1b1f7ea2d121521564f9ec"
    sha256 x86_64_linux:  "a4cda1c2aaa1b4fd3e5d324f7a3bb8aa338e3a299459599b0354c5592de79972"
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
    target = "x86_64-elf"
    system "./configure", "--target=#{target}",
                          "--enable-targets=x86_64-pep",
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
      .section .data
      .section .text
      .globl _start
      _start:
          movl $1, %eax
          movl $4, %ebx
          int $0x80
    ASM

    system bin/"x86_64-elf-as", "--64", "-o", "test-s.o", "test-s.s"
    assert_match "file format elf64-x86-64",
      shell_output("#{bin}/x86_64-elf-objdump -a test-s.o")
  end
end
