class Riscv64ElfBinutils < Formula
  desc "GNU Binutils for riscv64-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftpmirror.gnu.org/gnu/binutils/binutils-2.47.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.47.tar.bz2"
  sha256 "3068128c75cda9f898ccb4211d360246e8e195ffcc9dfb655b23ae23a54800e8"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_tahoe:   "aea21c1219539fcea27983817f48cbcbb654b87c1c212504d61fb04725a08615"
    sha256 arm64_sequoia: "acac25b80fedf3dd292f6e972e83451b12148fd436117837d52c34dbd9f58719"
    sha256 arm64_sonoma:  "b4c630c7b6745af567e2418c87c514afcfce51b982249516bdc9d352ad87cbb5"
    sha256 sonoma:        "9a2505a4fd66ada2606b91f436a9a5119ff069db53e24ac4fcca3447d2ae334f"
    sha256 arm64_linux:   "27f39b4aff2e100825ac30353fc241a0091fee631f04d89e6e8aad9f691ff58b"
    sha256 x86_64_linux:  "0f956bf769438213b7ea9bc36c79b7748eaebd76024b9f8f20f0e0c3e46d1572"
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
    (testpath/"test-s.s").write <<~ASM
      .section .text
      .globl _start
      _start:
          li a7, 93
          li a0, 0
          ecall
    ASM

    system bin/"riscv64-elf-as", "-o", "test-s.o", "test-s.s"
    assert_match "file format elf64-littleriscv",
                 shell_output("#{bin}/riscv64-elf-objdump -a test-s.o")
    assert_match "f()", shell_output("#{bin}/riscv64-elf-c++filt _Z1fv")
  end
end
