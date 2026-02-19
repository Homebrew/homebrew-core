class Riscv64ElfGdb < Formula
  desc "GNU debugger for riscv64-elf cross development"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftpmirror.gnu.org/gnu/gdb/gdb-17.1.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gdb/gdb-17.1.tar.xz"
  sha256 "14996f5f74c9f68f5a543fdc45bca7800207f91f92aeea6c2e791822c7c6d876"
  license "GPL-3.0-or-later"
  head "https://sourceware.org/git/binutils-gdb.git", branch: "master"

  livecheck do
    formula "gdb"
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "344d83c9a04d59afc809e82167085b7f433f3e71ce10d52327616fb2b1c59a27"
    sha256 arm64_sequoia: "7f1a33aeca41fa9cc246aa753c69e05475f922d6df4f1cc96baab10cd01f1ea4"
    sha256 arm64_sonoma:  "b4633f0c3f1d3cae9aa62d0da3714ec4f94ac84c7a8fed11434d0cac316a89e5"
    sha256 sonoma:        "93c7d4db868c46f356b600c6432a7d48547b949ccbacf95528e02d1d7456f767"
    sha256 arm64_linux:   "9688531223cf253300b484d52b3c535aa5c0361da5ce9b0bef84c3313f9193ba"
    sha256 x86_64_linux:  "38c247e15ce82e284a1e97d44bc8415094c7f475bb2f5f2e3e75d5a99e84670e"
  end

  depends_on "pkgconf" => :build
  depends_on "riscv64-elf-gcc" => :test
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "ncurses" # https://github.com/Homebrew/homebrew-core/issues/224294
  depends_on "python@3.14"
  depends_on "readline"
  depends_on "xz" # required for lzma support
  depends_on "zstd"

  uses_from_macos "expat", since: :sequoia # minimum macOS due to python

  # Workaround for https://github.com/Homebrew/brew/issues/19315
  on_sequoia :or_newer do
    on_intel do
      depends_on "expat"
    end
  end

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  on_linux do
    depends_on "zlib-ng-compat"
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
      --with-python=#{which("python3.14")}
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
