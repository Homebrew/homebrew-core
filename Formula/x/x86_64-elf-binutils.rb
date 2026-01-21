class X8664ElfBinutils < Formula
  desc "GNU Binutils for x86_64-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftpmirror.gnu.org/gnu/binutils/binutils-2.45.1.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.45.1.tar.bz2"
  sha256 "860daddec9085cb4011279136fc8ad29eb533e9446d7524af7f517dd18f00224"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_tahoe:   "017fab66df65e91f43c6793b186c1bb1ab8a78990b58f0cb96db566305f07df0"
    sha256 arm64_sequoia: "8695129fa2b5ed5e56a0175acae1d23ccbde76da5b91eb6c1f5f2c7af6c8a251"
    sha256 arm64_sonoma:  "c802af3a13575c6483e994f0dc0814532d91ce3446bc1a89555736dd7fa9caf7"
    sha256 sonoma:        "2933739ec3ac36989671b8a625cbc94322e0f1d456abf252f886d812b3d367ec"
    sha256 arm64_linux:   "95e7e3f28535fe0488c509367ecedbfd75aaed814fe5d63c719d409687bb7f96"
    sha256 x86_64_linux:  "607a0fc1dde64ac3b2f32d247946daafa4d8dd70002c85c239179608a4a12eee"
  end

  depends_on "pkgconf" => :build
  depends_on "zstd"

  uses_from_macos "zlib"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
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
