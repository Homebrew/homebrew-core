class X8664ElfGdb < Formula
  desc "GNU debugger for x86_64-elf cross development"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-10.2.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-10.2.tar.xz"
  sha256 "aaa1223d534c9b700a8bec952d9748ee1977513f178727e1bee520ee000b4f29"
  license "GPL-3.0-or-later"
  head "https://sourceware.org/git/binutils-gdb.git"

  bottle do
    sha256 arm64_big_sur: "922a0ed485b4ff144fcf876db7c50465e1a60566b9ea1ee25b57bd356f159a59"
    sha256 big_sur:       "d9c893cd48502f675e5ccfbf139c70dc811683ff8427ee12053af00d63800d4b"
    sha256 catalina:      "fc5398cdb8a918f3e0153c3467074145e69112fd42866c3dc8fee5a66869e8da"
    sha256 mojave:        "7f6d20cc6f1d7f23834614f2f159d8438732e31bb3375c380d64e8dd010232c1"
    sha256 high_sierra:   "bc725f791779a9400ab2b11d485ebba7e71aced9e6cef3365db614dbb273205c"
  end

  depends_on "x86_64-elf-gcc" => :test
  depends_on "python@3.9"
  depends_on "xz"

  uses_from_macos "zlib"

  # Fix for https://sourceware.org/bugzilla/show_bug.cgi?id=26949#c8
  # Remove when upstream includes this commit
  # https://sourceware.org/git/gitweb.cgi?p=binutils-gdb.git;h=b413232211bf
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/242630de4b54d6c57721e12ce88988a0f4e41202/gdb/gdb-10.2.patch"
    sha256 "36652e9d97037266650a3b31f9f39539c4b376d31016fa4fc325dc0aa7930acc"
  end

  def install
    args = %W[
      --target=x86_64-elf
      --prefix=#{prefix}
      --datarootdir=#{share}/x86_64-elf-gdb
      --disable-debug
      --disable-dependency-tracking
      --with-lzma
      --with-python=#{Formula["python@3.9"].opt_bin}/python3
      --with-system-zlib
      --disable-binutils
    ]

    mkdir "build" do
      system "../configure", *args
      system "make"

      system "make", "install-gdb"
    end

    mv include/"gdb", include/"x86_64-elf-gdb"
  end

  test do
    (testpath/"test.c").write "void _start(void) {}"
    system "#{Formula["x86_64-elf-gcc"].bin}/x86_64-elf-gcc", "-g", "-nostdlib", "test.c"
    assert_match "Symbol \"_start\" is a function at address 0x",
          shell_output("#{bin}/x86_64-elf-gdb -batch -ex 'info address _start' a.out")
  end
end
