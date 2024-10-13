class Riscv64ElfGdb < Formula
  desc "GNU debugger for riscv64-elf cross development"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-15.2.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-15.2.tar.xz"
  sha256 "83350ccd35b5b5a0cba6b334c41294ea968158c573940904f00b92f76345314d"
  license "GPL-3.0-or-later"
  head "https://sourceware.org/git/binutils-gdb.git", branch: "master"

  livecheck do
    formula "gdb"
  end

  bottle do
    sha256 arm64_sequoia: "5f7aba797e29ac7a43b5e16bbd6681bf2f58579861177aea7c300daa16c11b66"
    sha256 arm64_sonoma:  "ebfe7a157b16b5a2c6e88e45c02763892320fae8b320c33a044a239086e2c84b"
    sha256 arm64_ventura: "74e7d45007b562aae45502f466309d751243941d92aba2a6499427d1acaa1685"
    sha256 sonoma:        "54b820d8f942cc61441e84d0ee5ce3a2a471922ba098687a0f5278197b87f7e6"
    sha256 ventura:       "a7f888e84f77af88871f0855a9c6a1d2210af7a15336fac06f9826a0fdeb95f8"
    sha256 x86_64_linux:  "d9151e9effe890130f9d9d5114f36ce261aeddad7c27b17f831be109436c804d"
  end

  depends_on "riscv64-elf-gcc" => :test
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "python@3.12"
  depends_on "xz" # required for lzma support

  uses_from_macos "expat"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    target = "riscv64-elf"
    args = %W[
      --target=#{target}
      --datarootdir=#{share}/#{target}
      --includedir=#{include}/#{target}
      --infodir=#{info}/#{target}
      --mandir=#{man}
      --with-lzma
      --with-python=#{which("python3.12")}
      --with-system-zlib
      --disable-binutils
    ]

    mkdir "build" do
      system "../configure", *args, *std_configure_args
      ENV.deparallelize # Error: common/version.c-stamp.tmp: No such file or directory
      system "make"

      # Don't install bfd or opcodes, as they are provided by binutils
      system "make", "install-gdb"
    end
  end

  test do
    (testpath/"test.c").write "void _start(void) {}"
    system "#{Formula["riscv64-elf-gcc"].bin}/riscv64-elf-gcc", "-g", "-nostdlib", "test.c"
    assert_match "Symbol \"_start\" is a function at address 0x",
          shell_output("#{bin}/riscv64-elf-gdb -batch -ex 'info address _start' a.out")
  end
end
