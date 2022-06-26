class X8664ElfBinutils < Formula
  desc "GNU Binutils for x86_64-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.38.tar.xz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.38.tar.xz"
  sha256 "e316477a914f567eccc34d5d29785b8b0f5a10208d36bbacedcc39048ecfe024"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_monterey: "864342c720566a79bd30617e74365c206ebcc9ff1b20c2582ad647711a066b2d"
    sha256 arm64_big_sur:  "830cd093f6b42aca05346d933bcbb64a93a9eead2a5ec13920f6d313516ef730"
    sha256 monterey:       "42afd81a158f1fe611fb8ffb8e91b3436d706ff4ad78752a6b4b16d4a69c0cd5"
    sha256 big_sur:        "a43738a9cb6aca9e002aa843c0eef8f28c1e1ece2221d0009a4611b536676ab1"
    sha256 catalina:       "aa3cb73baeda44aae190cd7b8c3160dbabd42164aaf852f49fa65a7641b647ef"
    sha256 x86_64_linux:   "598e0d52a3eb37d1284e4f7ace39e6cdbb6d620db54252e25e895cbd230a3ec9"
  end

  uses_from_macos "texinfo"

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
