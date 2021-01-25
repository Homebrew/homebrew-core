class X8664ElfGdb < Formula
  desc "GNU debugger for i386-elf cross development"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-10.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-10.1.tar.xz"
  sha256 "f82f1eceeec14a3afa2de8d9b0d3c91d5a3820e23e0a01bbb70ef9f0276b62c0"
  license "GPL-3.0-or-later"
  head "https://sourceware.org/git/binutils-gdb.git"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "d9c893cd48502f675e5ccfbf139c70dc811683ff8427ee12053af00d63800d4b" => :big_sur
    sha256 "922a0ed485b4ff144fcf876db7c50465e1a60566b9ea1ee25b57bd356f159a59" => :arm64_big_sur
    sha256 "fc5398cdb8a918f3e0153c3467074145e69112fd42866c3dc8fee5a66869e8da" => :catalina
    sha256 "7f6d20cc6f1d7f23834614f2f159d8438732e31bb3375c380d64e8dd010232c1" => :mojave
    sha256 "bc725f791779a9400ab2b11d485ebba7e71aced9e6cef3365db614dbb273205c" => :high_sierra
  end

  depends_on "python@3.9"
  depends_on "xz"

  conflicts_with "gdb", because: "both install include/gdb, share/gdb and share/info"
  conflicts_with "i386-elf-gdb", because: "both install include/gdb, share/gdb and share/info"

  def install
    args = %W[
      --target=x86_64-elf
      --prefix=#{prefix}
      --disable-debug
      --disable-dependency-tracking
      --with-lzma
      --with-python=#{Formula["python@3.9"].opt_bin}/python3
      --disable-binutils
    ]

    mkdir "build" do
      system "../configure", *args
      system "make"

      system "make", "install-gdb"
    end
  end

  test do
    system "#{bin}/x86_64-elf-gdb", "#{bin}/x86_64-elf-gdb", "-configuration"
  end
end
