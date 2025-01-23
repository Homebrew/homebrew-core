class Riscv64ElfBinutils < Formula
  desc "GNU Binutils for riscv64-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.43.1.tar.bz2"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.43.1.tar.bz2"
  sha256 "becaac5d295e037587b63a42fad57fe3d9d7b83f478eb24b67f9eec5d0f1872f"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_sequoia:  "7c6baf0c3f68119fcfd6e68e521db8144376374797b6c0f5e0eb6f8ecada2a0c"
    sha256 arm64_sonoma:   "82f80d150e80febb95a4456fd579e51821b50aaac142245d621412218edcdd52"
    sha256 arm64_ventura:  "da2d4ac1c40f9b48919d4f30821789f0619a18a9736f08ae22a21dba6cc0afc9"
    sha256 arm64_monterey: "41828211729eef8dc3cdd1343766c9e9855292d887663e898fbc18a9de7f4a4d"
    sha256 sonoma:         "23d6c77cfd5a03b1fd9c604506bfc44bd4a058a90c0bcb203ff19d5b06fac2ba"
    sha256 ventura:        "548844c384553b11efa8e99f3505c1004ef34638b2140d3795d5229f8a7bdc9e"
    sha256 monterey:       "bce11024383da5f640178d2adec1263730450eedb22690fef9e1cb7b7c4dd074"
    sha256 x86_64_linux:   "2d20f3c9e5b38bd284237023d75cd87e34224390064af224929fd51cf740e0a2"
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
