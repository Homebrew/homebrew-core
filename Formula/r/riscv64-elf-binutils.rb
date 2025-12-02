class Riscv64ElfBinutils < Formula
  desc "GNU Binutils for riscv64-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftpmirror.gnu.org/gnu/binutils/binutils-2.45.1.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.45.1.tar.bz2"
  sha256 "860daddec9085cb4011279136fc8ad29eb533e9446d7524af7f517dd18f00224"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_tahoe:   "c6adf33de2958f438b2cd72db098d3d23afe29624c36e9806237c1c372fdd036"
    sha256 arm64_sequoia: "3f5a53e2037e52b9ef073c685fcf836cc7bbc5e0f18f21ee228b28881159f04c"
    sha256 arm64_sonoma:  "acb79220d02eabe7b29898151028fd703cbfeb3154ed374b3cce65b8a19ca2ec"
    sha256 sonoma:        "bebfc63f94890c5f80e457a9de5e6f3be952b2a5c3b0aa053c1cfd18b4387a01"
    sha256 arm64_linux:   "f48066697bbd57dba137971fac1fdb2163449a98efd7ce14a90452257aec66f1"
    sha256 x86_64_linux:  "ccf92985679f8f3d450396baa7c1b2553704f06619201e8207571351e8161e96"
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
