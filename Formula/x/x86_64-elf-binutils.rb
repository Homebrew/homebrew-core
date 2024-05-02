class X8664ElfBinutils < Formula
  desc "GNU Binutils for x86_64-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.42.tar.bz2"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.42.tar.bz2"
  sha256 "aa54850ebda5064c72cd4ec2d9b056c294252991486350d9a97ab2a6dfdfaf12"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_sonoma:   "408df853afe97f881f09a6863c9496255e154926fbca7bd7a26a5da99bd9d780"
    sha256 arm64_ventura:  "769d0166a2d363a9c453b2f0cb5f41045d82b489a1065fd1ec36f070adb466ea"
    sha256 arm64_monterey: "09970acd117822df6b2f9a252e7408db0b7fffe0374b9f5d2d63ce0a16ce35fd"
    sha256 sonoma:         "29a61d605995edf6b47b30e8975e9c713a5125bd9dfab6e0ffeb2ed2ece93789"
    sha256 ventura:        "3a7528efc85034f001b441e7620fee0b9af9e4077c831cd0ec419870c9ba35a4"
    sha256 monterey:       "4a16dff918cc61b37d8ca956986bab7ff8f75e3b951d579de0e3dbc4d6e72676"
    sha256 x86_64_linux:   "402b99039776f2d90825e678749c5a0bf2f04386a8457886beafaa2c9c12ce8e"
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
