class X8664ElfGdb < Formula
  desc "GNU debugger for x86_64-elf cross development"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-13.2.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-13.2.tar.xz"
  sha256 "fd5bebb7be1833abdb6e023c2f498a354498281df9d05523d8915babeb893f0a"
  license "GPL-3.0-or-later"
  head "https://sourceware.org/git/binutils-gdb.git", branch: "master"

  livecheck do
    formula "gdb"
  end

  bottle do
    sha256 arm64_ventura:  "74783daea09fab45ae35fc8ed84bd420f5ab4df32e5c62735cfee6aba6ab1a03"
    sha256 arm64_monterey: "a42b96e60233f1888d4119495302b61902980be6eed65c34ecc37a0758fb3237"
    sha256 arm64_big_sur:  "84a030000431eca152bbc60293d1fbb798414320c4413aa5f02b13ed15eda066"
    sha256 ventura:        "8195f23e309b24fca0cd37e1a29898f61e091974d0b4d227fe801b95dc6e80e3"
    sha256 monterey:       "6ce8a320bf2f0dab75b416ed7e20122011ad325a9e5bfe8b6c3148f4b8b6c544"
    sha256 big_sur:        "899e00bc69021647678f209791472971ae51fcadf09ffa093838a552a6eadc36"
    sha256 x86_64_linux:   "dcd787b5cb4da93114c81413acb6d6c50d92d10a844de1d314c856e85abe0980"
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
