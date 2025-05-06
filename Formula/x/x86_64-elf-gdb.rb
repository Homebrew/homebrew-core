class X8664ElfGdb < Formula
  desc "GNU debugger for x86_64-elf cross development"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-16.3.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-16.3.tar.xz"
  sha256 "bcfcd095528a987917acf9fff3f1672181694926cc18d609c99d0042c00224c5"
  license "GPL-3.0-or-later"
  head "https://sourceware.org/git/binutils-gdb.git", branch: "master"

  livecheck do
    formula "gdb"
  end

  bottle do
    sha256 arm64_sequoia: "28f100b92ecb7457ced120b8d0522a178c1c7b41602ce928a135573196f0f118"
    sha256 arm64_sonoma:  "f3bfe8ae0d22a8a29df3487ab9a02183c03ebc40aee4dbb791f951152739d451"
    sha256 arm64_ventura: "12f8ce79c5b517f25f323720050fb2f348e556f90cd510b4d58e3f5ae20fc3dc"
    sha256 sonoma:        "e4b1c236f1b4317c08f212b2ee18e12c511edf81adb3a376697da97e286b88c0"
    sha256 ventura:       "6a08a716548bb8e045f191db3854584be6d48619a64886e69d2f6617bf09c623"
    sha256 arm64_linux:   "8b54865a39c1be49422e670ffd3992d391159acba028d87a1b73affa796c86cd"
    sha256 x86_64_linux:  "38caa41e87bae9d85259c0497a9300af7c51f236e299476a8fc38da29f7d76ca"
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
