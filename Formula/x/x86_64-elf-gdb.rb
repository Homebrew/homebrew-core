class X8664ElfGdb < Formula
  desc "GNU debugger for x86_64-elf cross development"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-16.2.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-16.2.tar.xz"
  sha256 "4002cb7f23f45c37c790536a13a720942ce4be0402d929c9085e92f10d480119"
  license "GPL-3.0-or-later"
  head "https://sourceware.org/git/binutils-gdb.git", branch: "master"

  livecheck do
    formula "gdb"
  end

  bottle do
    sha256 arm64_sequoia: "de74875cbd1859e8c1fa82848274c39547668f7be7d97b722177017c61ea8497"
    sha256 arm64_sonoma:  "30072350c40b7764e703fef9a4829e3ed6b7d6e9aa78845a5c3f9e00a4ce094f"
    sha256 arm64_ventura: "5992bcfc7efda98494052c965cb6b0360e1680c2c1b6ac6299d962d2cde71b01"
    sha256 sonoma:        "8a0f7aca58e0736c3faead51e6f80fad9565a67e8097214c85ead9fd913ca874"
    sha256 ventura:       "184ee71eb79f730ca61b2edbd673cfd096b9085b792547070cf45e9245fd5360"
    sha256 arm64_linux:   "7d5cb5a359150d67f315077aeffdc64e2ad255b3eec0a9a3abc7ab1731fc2b8f"
    sha256 x86_64_linux:  "0e74c4348f72702b1ddf300469815ef0e919780a17176dcdd8c2c5550fa833e1"
  end

  depends_on "x86_64-elf-gcc" => :test

  depends_on "gmp"
  depends_on "mpfr"
  depends_on "python@3.13"
  depends_on "xz" # required for lzma support

  uses_from_macos "expat", since: :sequoia # minimum macOS due to python
  uses_from_macos "ncurses"
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
      --with-lzma
      --with-python=#{which("python3.13")}
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
    system Formula["x86_64-elf-gcc"].bin/"x86_64-elf-gcc", "-g", "-nostdlib", "test.c"

    output = shell_output("#{bin}/x86_64-elf-gdb -batch -ex 'info address _start' a.out")
    assert_match "Symbol \"_start\" is a function at address 0x", output
  end
end
