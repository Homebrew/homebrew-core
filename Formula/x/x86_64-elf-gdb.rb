class X8664ElfGdb < Formula
  desc "GNU debugger for x86_64-elf cross development"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-15.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-15.1.tar.xz"
  sha256 "38254eacd4572134bca9c5a5aa4d4ca564cbbd30c369d881f733fb6b903354f2"
  license "GPL-3.0-or-later"
  head "https://sourceware.org/git/binutils-gdb.git", branch: "master"

  livecheck do
    formula "gdb"
  end

  bottle do
    sha256 arm64_sonoma:   "84e2e9c2884955b6e25f6bd5ee7c5a2da6eaa99184cb54e8a33a392f51b9f444"
    sha256 arm64_ventura:  "f08d41519aaa97d4deee3b0455788d90fddec1f09773054366f2f9adc93d6a57"
    sha256 arm64_monterey: "9ddbf58dbfe0118dc3242d9411b4ed07ef4907b2ebf1d4bc8ce3f5b37329767f"
    sha256 sonoma:         "c1cd75ed4c639df8d02c30ab1849e6c5fc7cd78c918ec290fdd284457e160d43"
    sha256 ventura:        "8695cf80cd0b9cc541cf6b54c050fd0ac3351fa0fe1d2b1219d4fb856830ebfd"
    sha256 monterey:       "2d029b12da2dd792a6f9f59d87b7764024bbd6cfd9e25d318a26d0585cd8ac30"
    sha256 x86_64_linux:   "3cc4bea8f108fb221f12a03a931deebf13aaf7fdfff84733973d028f25005810"
  end

  depends_on "x86_64-elf-gcc" => :test

  depends_on "gmp"
  depends_on "mpfr"
  depends_on "python@3.12"
  depends_on "xz" # required for lzma support

  uses_from_macos "expat"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

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
    system "#{Formula["x86_64-elf-gcc"].bin}/x86_64-elf-gcc", "-g", "-nostdlib", "test.c"

    output = shell_output("#{bin}/x86_64-elf-gdb -batch -ex 'info address _start' a.out")
    assert_match "Symbol \"_start\" is a function at address 0x", output
  end
end
