class X8664ElfBinutils < Formula
  desc "GNU Binutils for x86_64-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftpmirror.gnu.org/gnu/binutils/binutils-2.47.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.47.tar.bz2"
  sha256 "3068128c75cda9f898ccb4211d360246e8e195ffcc9dfb655b23ae23a54800e8"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_tahoe:   "ce3d78549c5aa953f310fc1d743b2dd427a5fba65f881f8b979b6138ef71a81a"
    sha256 arm64_sequoia: "3db6a67155736339fec90df66d6d38205e29708d1440a6b553001242908a59b8"
    sha256 arm64_sonoma:  "fd74784a2969ce6dddea187a61699e72da76aaf9e900528beeb9633de1e54efe"
    sha256 sonoma:        "c50dc0e2590155cccf51de4ac8ef0093428776b9c96072e08ca07d1211ecbeba"
    sha256 arm64_linux:   "68eaa7d5ab55ba3c9c5022df15da1ab7b83214aae6682c46b5c786162835eaac"
    sha256 x86_64_linux:  "7ab21645a06b2da59a908a4549144df68b943d88fa10aef09378570963aa1fe5"
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
