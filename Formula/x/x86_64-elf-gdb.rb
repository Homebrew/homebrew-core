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

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "2d92d3c7708d8cf17556c3748831eaea21894c809f39d24e6c1a855a96391f9a"
    sha256 arm64_sequoia: "3c3cd7c5547c24c5477a5bfdf20070f20eb0c44719473104ab09cd7075aea216"
    sha256 arm64_sonoma:  "8761611d1fb5160c0e64811c0b819730d3e4f5e406397cf1e6eea856521aafb8"
    sha256 sonoma:        "46f0b82e3c175bfae670bd3f43832e90f5a965ed6b6cadc2840c67ab39931492"
    sha256 arm64_linux:   "3e8484345406407e11b19520c89d9c6b487c7e5a66d0ceeda8d6461085e85228"
    sha256 x86_64_linux:  "e574137ef92334df9b4a1b727ae414599c02c4d4969cf45a9fd3d3e6eee4d261"
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
