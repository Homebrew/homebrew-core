class X8664ElfGdb < Formula
  desc "GNU debugger for x86_64-elf cross development"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-12.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-12.1.tar.xz"
  sha256 "0e1793bf8f2b54d53f46dea84ccfd446f48f81b297b28c4f7fc017b818d69fed"
  license "GPL-3.0-or-later"
  revision 1
  head "https://sourceware.org/git/binutils-gdb.git", branch: "master"

  livecheck do
    formula "gdb"
  end

  bottle do
    sha256 arm64_ventura:  "8f54e210560e8955c6958e7fc3cf393d7f80802daa05388a219ef263d46b6992"
    sha256 arm64_monterey: "191c3e0bad3cc372dea61561969af4677adde8ab7ef9cf68fba19513d284d925"
    sha256 arm64_big_sur:  "63bb893d29d721407ef3c87f05fc3e05b69b0a42e6d7b384585200cc0dd6234b"
    sha256 ventura:        "23e916acc24c7d36b23bf248c872675a83d78ff16739cef9fa8c6ba2715618b4"
    sha256 monterey:       "08dae6d26be05a6659f7e055e4faa57fccb7bcc4bada84e833230bd93681c9a1"
    sha256 big_sur:        "d7ebcc85c5821a8f68ccf90200cc765dad25f8ebf274643399d71384bbfb197b"
    sha256 catalina:       "22e6d34b47387dceee96d9f4dd1952b8f11b9c4f6d1d55d9de3558eaf498e4cc"
    sha256 x86_64_linux:   "91a4fbb0eab6d2a6558cc0b9248b0e6e61c23a4faa0b62edb303372a018dbebe"
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
