class Riscv64ElfBinutils < Formula
  desc "GNU Binutils for riscv64-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.42.tar.bz2"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.42.tar.bz2"
  sha256 "aa54850ebda5064c72cd4ec2d9b056c294252991486350d9a97ab2a6dfdfaf12"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_sonoma:   "09a3369af25004d0008a0ec7390f2ae1ba0ba3a7ad132ca018ee919e961f8df8"
    sha256 arm64_ventura:  "e867436303e7352f3bd543a1300dae09237544bf4f8b1698c68f7d63ea2e3644"
    sha256 arm64_monterey: "36f5c8b2032ac730408734462c70939001ee516c134140b8fe5ddce437d317f4"
    sha256 sonoma:         "e3d07fffc1ece4c8f50ce5218210e5a46a493ead0955811708a46d74a12b88bc"
    sha256 ventura:        "8f7f40be28d714274e65f8181cf07c159713db80654b207dcfa9e4b07426cd28"
    sha256 monterey:       "77de440e53b00249fcd787dfee0b093dbb7f2fadfa727b0d6d1939feb04a5e62"
    sha256 x86_64_linux:   "6491d27ff8c7c5c959db2d388aeb6a996536d01fbe5a79c7bd631a462ab08be1"
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
