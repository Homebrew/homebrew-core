class X8664ElfBinutils < Formula
  desc "GNU Binutils for x86_64-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.43.1.tar.bz2"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.43.1.tar.bz2"
  sha256 "becaac5d295e037587b63a42fad57fe3d9d7b83f478eb24b67f9eec5d0f1872f"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_sequoia:  "55454cfd30d76e3f05f5bf39c1ec876f8a955a2f31295bc8c2bfb900dad83968"
    sha256 arm64_sonoma:   "6b3304e1337d392828c800cecca791267f3682c7d7ecc406648e0ac01726698f"
    sha256 arm64_ventura:  "339e160848752b6486f5364369749b333dfa43ce2cf29f2de2105b8c683ecfb4"
    sha256 arm64_monterey: "b71f4dd4f0181b5bb1ab8a5c56253346f919020f13e17938824e98eff182dfce"
    sha256 sonoma:         "0791226bb834c669237c872b14878ea182ea7f009622826cc6b6eeb8bdb3455c"
    sha256 ventura:        "f494ac13ac40d3eb258accf5fc635d6036e06ff617f6e9a033f9f52d1644c3d9"
    sha256 monterey:       "d3336e5c8c288f63f980f081648ce62fe6bd85d6bdac64bcad96d24a8e8ef6d1"
    sha256 x86_64_linux:   "f0ed12582580e7fa52c4a1db664ceeef57c921ba29aa110673ae6aeb7ed3e7cf"
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
