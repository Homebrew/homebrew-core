class X8664ElfGdb < Formula
  desc "GNU debugger for x86_64-elf cross development"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftpmirror.gnu.org/gdb/gdb-18.1.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gdb/gdb-18.1.tar.xz"
  sha256 "cd9fc3fe2b47743840e42c1592d3d87f8302eb18639c0b8b4ba0898002e2348f"
  license "GPL-3.0-or-later"
  head "https://sourceware.org/git/binutils-gdb.git", branch: "master"

  livecheck do
    formula "gdb"
  end

  bottle do
    rebuild 2
    sha256 arm64_golden_gate: "3ef4ffcb0fd2789a7c4dcd777289341d5bf0d95b59abde3d89c15a0bcda2268e"
    sha256 arm64_tahoe:       "9e7e6abb63af266858bb9dcd58e1cfda0c6589638cbe8b16955f50c477df9651"
    sha256 arm64_sequoia:     "dbc7eafda9bff3b2b560f48bc43a575cb8c5e6322b1f6e4b7c93d4046fc5c96a"
    sha256 arm64_linux:       "7edd5287e7185a469a7948fab29fc2e9f8ab55bdbc54c7bf01954f76da5c5a41"
    sha256 x86_64_linux:      "78f297402437d5931c2aa5bc8fdd2bdcdf44c1194dc1d4989700547ecccd39d7"
  end

  depends_on "pkgconf" => :build
  depends_on "texinfo" => :build
  depends_on "x86_64-elf-gcc" => :test
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "python@3.15"
  depends_on "readline"
  depends_on "xz" # required for lzma support
  depends_on "zstd"

  uses_from_macos "expat", since: :sequoia # minimum macOS due to python
  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Work around `mvwaddstr` and `mvwaddnstr` in macOS ncurses writing nothing,
  # which leaves TUI windows such as `layout regs` empty
  patch do
    file "Patches/gdb/macos-system-ncurses.patch"
    type :unofficial
    resolves "https://github.com/Homebrew/homebrew-core/issues/224294"
  end

  deny_network_access!

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
      --with-python=#{python3}
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
    system formula_opt_bin("x86_64-elf-gcc")/"x86_64-elf-gcc", "-g", "-nostdlib", "test.c"

    output = shell_output("#{bin}/x86_64-elf-gdb -batch -ex 'info address _start' a.out")
    assert_match "Symbol \"_start\" is a function at address 0x", output
  end
end
