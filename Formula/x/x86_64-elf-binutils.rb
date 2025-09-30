class X8664ElfBinutils < Formula
  desc "GNU Binutils for x86_64-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftpmirror.gnu.org/gnu/binutils/binutils-2.45.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.45.tar.bz2"
  sha256 "1393f90db70c2ebd785fb434d6127f8888c559d5eeb9c006c354b203bab3473e"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_tahoe:   "0d79ce39624e7c9037d41f95acc84fd886777ddcd01c071de121cf0f83aa5bdc"
    sha256 arm64_sequoia: "7ac8f5424c60ba0558083e0278ffa09a28a20210eac18ba2b45bcc500d600796"
    sha256 arm64_sonoma:  "646898a98d4d195fe03e4c5443584ba940b21068b92a004dc1273e9a50fc46cd"
    sha256 arm64_ventura: "1dd965f9429b5d1ece2c1ce3fb30f8bca190e051ae25006cffb16fc41ac4fdbf"
    sha256 sonoma:        "28028a70c8a0a893a0f2055a14ab0bd69a7e467d18861219f44f6cc7f708a38b"
    sha256 ventura:       "998e1cc524b609dc43a0b66c78b74cf170cced84b6f6f56bd3500a59ea358768"
    sha256 arm64_linux:   "1769474ec01f828f92d506c47ae26bf6a31159015953318941fc69f2fe3994a1"
    sha256 x86_64_linux:  "5e0c35754c97ded783b562e61727aa3b717aced1d6f43a7a766dc2e0df45c284"
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
