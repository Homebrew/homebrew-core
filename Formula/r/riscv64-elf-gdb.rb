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

  bottle do
    sha256 arm64_sequoia: "fc182c3f9b43f0706c5e38ad0cc227b5a0462f413b3e7975137baafcbf9f75bb"
    sha256 arm64_sonoma:  "0e376f70fab060eb7a19ea146565b21f25c39fad626b9345f16ba541f98b7e05"
    sha256 arm64_ventura: "c6289ed531b09195c7288e49bdd5ea128b7b95d0c28b15408a8a24041dbdc748"
    sha256 sonoma:        "67fbc5381005c1223d1c3bdd444f7114c748448913a81daa57db9d27df947b1b"
    sha256 ventura:       "efcdc16f939bad13162938caf972b390bbd62be3f5888af79bf0062d6f87adfb"
    sha256 arm64_linux:   "1cec187ec64758bdacd6fb7707fbc7851a70efcbe6ba3f42881c0889d19b710e"
    sha256 x86_64_linux:  "8bf342fa7ae748f0917c42d37db64a0b44e7f2f5c867898f975b93928bd3c292"
  end

  depends_on "riscv64-elf-gcc" => :test
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
    target = "riscv64-elf"
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
    system Formula["riscv64-elf-gcc"].bin/"riscv64-elf-gcc", "-g", "-nostdlib", "test.c"
    assert_match "Symbol \"_start\" is a function at address 0x",
          shell_output("#{bin}/riscv64-elf-gdb -batch -ex 'info address _start' a.out")
  end
end
