class X8664ElfBinutils < Formula
  desc "GNU Binutils for x86_64-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.41.tar.bz2"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.41.tar.bz2"
  sha256 "a4c4bec052f7b8370024e60389e194377f3f48b56618418ea51067f67aaab30b"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_ventura:  "0b215aa3c7eb7e02560ad78336948f5b785f82f1e44f51d01a064381b268620b"
    sha256 arm64_monterey: "bb3ceda65be93daf1843c193b7ad7bd7f21cfdcffb7c3345c1533ccc2afd9442"
    sha256 arm64_big_sur:  "85b7813f719f4be660c3e53faa7951473dd61661c80513ef6569783e0539b05f"
    sha256 ventura:        "fe80fac828ea3708ed487e8164a2f5ae1b1dd6de3287f7e5640b2d683fa956e0"
    sha256 monterey:       "1c7143c88fced456c2a57a1d002464546e24da925492ad08084c20c39c5df8a0"
    sha256 big_sur:        "c4bdc39b6a3af918b61c2f60264174444d66aa9392bdd75cc433ed0166055399"
    sha256 x86_64_linux:   "0fc5cae1e9dd2f3d4a50f3dc5fc85c5788f1301489cdeb21dacf8006921e7638"
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
