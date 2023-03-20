class X8664ElfBinutils < Formula
  desc "GNU Binutils for x86_64-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.40.tar.bz2"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.40.tar.bz2"
  sha256 "f8298eb153a4b37d112e945aa5cb2850040bcf26a3ea65b5a715c83afe05e48a"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_ventura:  "8f0a866e18e44d9413845e8bb0ba5527e01bcc835e980e6d1d5e7292cef26901"
    sha256 arm64_monterey: "a2d393d0837ca5db7a19cd9d07e815fdbb6e5f8394f7f96515ea850db8dffe38"
    sha256 arm64_big_sur:  "543f9d1fef3247bedccb8af2d549540dd7c4055c93e4954e6ea0c7e571fd5ad6"
    sha256 ventura:        "d60505180226caccd406224051004cab2d7963ff5801be4a475d6d58ed61bab1"
    sha256 monterey:       "c6c0f08d05e8fcfc8e26cf1524e41864f855b9172044683fa0237b0c411b2dcf"
    sha256 big_sur:        "d5265d1cddf7001c67c6b84a8fcf26dd8b8e55272cc489425d25a8eb14f1ef15"
    sha256 x86_64_linux:   "b9e049fa35e529756295978b903861afec942eed6727c008cd5dfda1bcb29b23"
  end

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
