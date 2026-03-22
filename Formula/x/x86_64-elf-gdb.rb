class X8664ElfGdb < Formula
  desc "GNU debugger for x86_64-elf cross development"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftpmirror.gnu.org/gnu/gdb/gdb-17.1.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gdb/gdb-17.1.tar.xz"
  sha256 "14996f5f74c9f68f5a543fdc45bca7800207f91f92aeea6c2e791822c7c6d876"
  license "GPL-3.0-or-later"
  head "https://sourceware.org/git/binutils-gdb.git", branch: "master"

  livecheck do
    formula "gdb"
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "ffc4d91060bee0a77349a4197c4693478b6633b423dfa0541ca0ff5667c1a0ee"
    sha256 arm64_sequoia: "df1f80eeb99a9d22809f68670468532a4b80671817cc5673c30b1b269533d981"
    sha256 arm64_sonoma:  "955b0c8f0b10163206ad3a889440f2f855b96357d875fca9779ec07d77508fd6"
    sha256 sonoma:        "40968878872648a819ced969094383478b7dbfee0ce34a01420a2f616cda5f60"
    sha256 arm64_linux:   "dfb0bc11911d42e039f52cd1014d59c612ce4a4427f2c58add1efd709c5d857f"
    sha256 x86_64_linux:  "37d0aeaaf689eb0a90eb915f02cb99eea4c89d0009a932b12323f948449b86c7"
  end

  depends_on "pkgconf" => :build
  depends_on "x86_64-elf-gcc" => :test
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
    target = "x86_64-elf"
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
    system Formula["x86_64-elf-gcc"].bin/"x86_64-elf-gcc", "-g", "-nostdlib", "test.c"

    output = shell_output("#{bin}/x86_64-elf-gdb -batch -ex 'info address _start' a.out")
    assert_match "Symbol \"_start\" is a function at address 0x", output
  end
end
