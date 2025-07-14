class Riscv64ElfGdb < Formula
  desc "GNU debugger for riscv64-elf cross development"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-16.3.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-16.3.tar.xz"
  sha256 "bcfcd095528a987917acf9fff3f1672181694926cc18d609c99d0042c00224c5"
  license "GPL-3.0-or-later"
  head "https://sourceware.org/git/binutils-gdb.git", branch: "master"

  livecheck do
    formula "gdb"
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "0496ebf857fd732860b99a501ee7d65e7ccbbd169042413ce702c5444ded3f1e"
    sha256 arm64_sonoma:  "fe42283e0b56442eb93c110b6a308182324e1eeff5c7cf43cd7d768894485eb0"
    sha256 arm64_ventura: "96ea7bd381f364f0e5875560a9fd7bef09add6395a53af8d4bea2f12e81e51ec"
    sha256 sonoma:        "a002cb7302b7dfe52feab0134b31284196a52e65e9bb59f6d00b82ae97960cbd"
    sha256 ventura:       "05be81fd9d083a1e3996ebb84fae6dfbe60014193e983a9fcaf13fd4569fdadf"
    sha256 arm64_linux:   "4e3030c62a51aeb071e926c8846f9b5fde6c6b1b6ccce58979219cca0826effd"
    sha256 x86_64_linux:  "a85cca3d9b3db5281ad8fd34174be330b290d4f6dae08c8029037bb9e8c2d60e"
  end

  depends_on "pkgconf" => :build
  depends_on "riscv64-elf-gcc" => :test
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "ncurses" # https://github.com/Homebrew/homebrew-core/issues/224294
  depends_on "python@3.13"
  depends_on "readline"
  depends_on "xz" # required for lzma support
  depends_on "zstd"

  uses_from_macos "expat", since: :sequoia # minimum macOS due to python
  uses_from_macos "zlib"

  # Workaround for https://github.com/Homebrew/brew/issues/19315
  on_sequoia :or_newer do
    on_intel do
      depends_on "expat"
    end
  end

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
      --disable-binutils
      --disable-nls
      --enable-tui
      --with-curses
      --with-expat
      --with-lzma
      --with-python=#{which("python3.13")}
      --with-system-readline
      --with-system-zlib
      --with-zstd
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
    system Formula["riscv64-elf-gcc"].bin/"riscv64-elf-gcc", "-g", "-nostdlib", "test.c"
    assert_match "Symbol \"_start\" is a function at address 0x",
          shell_output("#{bin}/riscv64-elf-gdb -batch -ex 'info address _start' a.out")
  end
end
