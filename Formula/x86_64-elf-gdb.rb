class X8664ElfGdb < Formula
  desc "GNU debugger for x86_64-elf cross development"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-13.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-13.1.tar.xz"
  sha256 "115ad5c18d69a6be2ab15882d365dda2a2211c14f480b3502c6eba576e2e95a0"
  license "GPL-3.0-or-later"
  head "https://sourceware.org/git/binutils-gdb.git", branch: "master"

  livecheck do
    formula "gdb"
  end

  bottle do
    sha256 arm64_ventura:  "199da403970bc0baf0bed60df15a49cb0d64a7eea85766f0760416a1ed2c2f85"
    sha256 arm64_monterey: "ce87fbda3e4af46e528f0ff95c3d01c808071feeb7292339d031f9f3b03ca1df"
    sha256 arm64_big_sur:  "54cee2a6c6de575a10034f0899fdbf0b45baa9ffc29dbb9093bb234ba222e3c0"
    sha256 ventura:        "ca8dd58e837408a295202e214efdaa5d4d16debeaab70981d8a00e04ff3588a9"
    sha256 monterey:       "5b6bfec110bb9ca1d9dda2b62e641c0c3bb68d6f246732ca12e3a1773a9012a4"
    sha256 big_sur:        "12f9a5e92158320dd6328c0405d1a4d8ae15e0b249d6b120d23a6047deeb6605"
    sha256 x86_64_linux:   "3f6c92261890700f213ad3e687102d6c61c25ac0814bc0b64b2d25ed898c7991"
  end

  depends_on "x86_64-elf-gcc" => :test
  depends_on "gmp"
  depends_on "python@3.11"
  depends_on "xz" # required for lzma support

  uses_from_macos "zlib"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    target = "x86_64-elf"
    args = %W[
      --target=#{target}
      --prefix=#{prefix}
      --datarootdir=#{share}/#{target}
      --includedir=#{include}/#{target}
      --infodir=#{info}/#{target}
      --mandir=#{man}
      --disable-debug
      --disable-dependency-tracking
      --with-lzma
      --with-python=#{Formula["python@3.11"].opt_bin}/python3.11
      --with-system-zlib
      --disable-binutils
    ]

    mkdir "build" do
      system "../configure", *args
      ENV.deparallelize # Error: common/version.c-stamp.tmp: No such file or directory
      system "make"

      # Don't install bfd or opcodes, as they are provided by binutils
      system "make", "install-gdb"
    end
  end

  test do
    (testpath/"test.c").write "void _start(void) {}"
    system "#{Formula["x86_64-elf-gcc"].bin}/x86_64-elf-gcc", "-g", "-nostdlib", "test.c"
    assert_match "Symbol \"_start\" is a function at address 0x",
          shell_output("#{bin}/x86_64-elf-gdb -batch -ex 'info address _start' a.out")
  end
end
