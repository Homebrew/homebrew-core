class X8664ElfBinutils < Formula
  desc "GNU Binutils for x86_64-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.44.tar.bz2"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.44.tar.bz2"
  sha256 "f66390a661faa117d00fab2e79cf2dc9d097b42cc296bf3f8677d1e7b452dc3a"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_sequoia: "2afacd61b85a74db24bf4d3f307e9c18ca5b7144c5d79d00db82c7f3e5d1add6"
    sha256 arm64_sonoma:  "4215b24625bf23b01a6e6a1d667f812794784f3a58b7045568f63807a1663f9c"
    sha256 arm64_ventura: "d25d18b7765a1757c299d2a8745b15a7a0d8e9a57e28b602802b313d5be1ca5b"
    sha256 sonoma:        "66b1a985e3174d0ee92f25c4a4d16c08d973ce5d500057c3cafbac6c9d8d0b0e"
    sha256 ventura:       "66fd8173cc8e438f22e4921bf64cd570047eb8a19cff0ae3d99e95a59e79d7d1"
    sha256 arm64_linux:   "7eb1f372ca29b1075657e32b186f4bb0de3951e985c9b32a20ca3ed5f514c30d"
    sha256 x86_64_linux:  "a40dc5fe1fd0de0ce1877546c73423bbe4bd6cccdccf24dc8f34b695b74e5dc4"
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
