class Riscv64ElfBinutils < Formula
  desc "GNU Binutils for riscv64-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftpmirror.gnu.org/gnu/binutils/binutils-2.46.0.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.46.0.tar.bz2"
  sha256 "0f3152632a2a9ce066f20963e9bb40af7cf85b9b6c409ed892fd0676e84ecd12"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_tahoe:   "d37df2f1817b189621420013525be45c9b1a9186b0bc17beb35595ceeda44a07"
    sha256 arm64_sequoia: "f899cf838014e5644b80e7878792305b7cc707c806ee9fd973d4dcdeddba9d67"
    sha256 arm64_sonoma:  "320d51e1e896e66f428893c90badbc072e624b02498fbf700d47cb0404403a7b"
    sha256 sonoma:        "26d02e863630ff329c19f8d39564304bad95d7ca51c341d7af04dae0f86e080e"
    sha256 arm64_linux:   "47489b6cccf3482cc9b883688e71b72962864725bbda63970b9abb2ea441db3e"
    sha256 x86_64_linux:  "bfbdc564238f10a6d02c7c7d40a9a2369291b248134d479914bf57b630ad9029"
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
