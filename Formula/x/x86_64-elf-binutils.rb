class X8664ElfBinutils < Formula
  desc "GNU Binutils for x86_64-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftpmirror.gnu.org/gnu/binutils/binutils-2.46.0.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.46.0.tar.bz2"
  sha256 "0f3152632a2a9ce066f20963e9bb40af7cf85b9b6c409ed892fd0676e84ecd12"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_tahoe:   "cc2fd0bd5361b23b54cbaba509a638a71e4bb1b46c0eb55e16bdc162f56dc50d"
    sha256 arm64_sequoia: "6bb083b167629cab860b582f570975dede7cbe92d9d2ed11fd42c9b31986e906"
    sha256 arm64_sonoma:  "8a6a43d713ad52abd626e68e0da76d76fae244f6c928e4e85027025de74d21a0"
    sha256 sonoma:        "5dd39aa5653ee74a4eab3cb11e5fc9dd91aee444afda6a090bd49114c1530e09"
    sha256 arm64_linux:   "68bc76e5cb50d3cbebd9c562ba5f98845c332ef99e650100b00b16dba7b4594e"
    sha256 x86_64_linux:  "bfac42c981aca755c42bbfdb55a2bd5cb8784fb56895f9bfc7afc36c49cc4fe7"
  end

  depends_on "pkgconf" => :build
  depends_on "zstd"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  on_linux do
    depends_on "zlib-ng-compat"
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
