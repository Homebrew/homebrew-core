class Riscv64ElfBinutils < Formula
  desc "GNU Binutils for riscv64-elf cross development"
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
    sha256 arm64_sonoma:   "3202dea99c33e7819903e607aa6121375966030d5a86db8a6f5dc9b7024c4302"
    sha256 arm64_ventura:  "ecb9b680bf4303d25f717443d807f3b03e82e46bb99dbd9cba8496a4343426a3"
    sha256 arm64_monterey: "09b479bcc3959438c476b60ec6df8f7287b0eaa868d251ef90418b11ba3eb00b"
    sha256 sonoma:         "95bdfe7ed2536be364581503a208a396eca32b2a7b88d376bfc2d1924ef16b78"
    sha256 ventura:        "875f7f662cd4f5e4a372e1bb17753f9a1e45ab5db5749d32e453a31df834cd1d"
    sha256 monterey:       "deed0c9650efc0b95eee929909358fdd0bfc402c7411d2b5d2b1ff0f0781a0eb"
    sha256 x86_64_linux:   "f626a9b181609369eab79fcd4711c6b3c40eca3ed9760f1248a08a6d354ad5dd"
  end

  depends_on "pkg-config" => :build
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
    (testpath/"test-s.s").write <<~EOS
      .section .text
      .globl _start
      _start:
          li a7, 93
          li a0, 0
          ecall
    EOS
    system "#{bin}/riscv64-elf-as", "-o", "test-s.o", "test-s.s"
    assert_match "file format elf64-littleriscv",
                 shell_output("#{bin}/riscv64-elf-objdump -a test-s.o")
    assert_match "f()", shell_output("#{bin}/riscv64-elf-c++filt _Z1fv")
  end
end
