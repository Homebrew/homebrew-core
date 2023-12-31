class X8664ElfBinutils < Formula
  desc "GNU Binutils for x86_64-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.41.tar.bz2"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.41.tar.bz2"
  sha256 "a4c4bec052f7b8370024e60389e194377f3f48b56618418ea51067f67aaab30b"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_sonoma:   "cf8c0e3ae45ac7cf79dd98607d5e782d129d9ac4bc46a4aeecb96eaa4d8cf4b2"
    sha256 arm64_ventura:  "730603cd47d8652f91f2e2496525057e22cb9db673b492260003ce8dd3239d0d"
    sha256 arm64_monterey: "dda1077b1462f69230b6f87613bcb48edd139b116a911973bfa587e75a807cd0"
    sha256 sonoma:         "1ed94d2ac0a812327a7955dafeeb98ae86dad7ffebbcbcb9c7f868bf2ecbe1e6"
    sha256 ventura:        "04298966651f9a912db27019f23b5dac9e8ace157f7bc54cd45d6fb8ac929f44"
    sha256 monterey:       "cb79fc69d9f52670c90f7ec9ee0e31088576d7766764ec1174531155b1c97119"
    sha256 x86_64_linux:   "0f39facf2333ff7b057ce2953567a067fe5425122fae9b4ebed30e5224b30fa8"
  end

  depends_on "pkg-config" => :build
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
