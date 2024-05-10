class Riscv64ElfGdb < Formula
  desc "GNU debugger for riscv64-elf cross development"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-14.2.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-14.2.tar.xz"
  sha256 "2d4dd8061d8ded12b6c63f55e45344881e8226105f4d2a9b234040efa5ce7772"
  license "GPL-3.0-or-later"
  head "https://sourceware.org/git/binutils-gdb.git", branch: "master"

  livecheck do
    formula "gdb"
  end

  bottle do
    sha256 arm64_sonoma:   "eed85e69e68619ae73c7e832dfdc1e68db0b5a5954de8316e339cfa264d77888"
    sha256 arm64_ventura:  "3c56697016096d5acd6607ebebacb70ea52ebe0631ed1ec440b7d4ec06b6ac6a"
    sha256 arm64_monterey: "f797740f74d78a1b102b7e3d1a03805189eb5d7f4b17c4e478f33bbbde461040"
    sha256 sonoma:         "b6934f3146b90ec2ce91c6b1c4c9c5afc2b17c0a17d4828141b1203d30f3bce2"
    sha256 ventura:        "35f213aea2ae027b406afed1d9c0c38fbe9fbeee17077c3d1f13b150af5d848d"
    sha256 monterey:       "12f2465df8d61b3f07b6ff46be406daae87aa370da7ebbffbafa52e27dfeb579"
    sha256 x86_64_linux:   "21ffe2c21e812d498f36fb63b7a86e372ccf5eaafa4780334ae844382dd8d951"
  end

  depends_on "riscv64-elf-gcc" => :test
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "python@3.12"
  depends_on "xz" # required for lzma support

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
