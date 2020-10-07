class X8664ElfGdb < Formula
  desc "GNU debugger for i386-elf cross development"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-9.2.tar.xz"
  sha256 "360cd7ae79b776988e89d8f9a01c985d0b1fa21c767a4295e5f88cb49175c555"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 "dfe4806259f346a687fdd33e04c0380a3e29042359d0035649bc921197482472" => :catalina
    sha256 "e791fd5b2c8bdf7c64574615dc0e5aeea5022b5f18beb2a92586ef777b999578" => :mojave
    sha256 "08a7d238e78d7cda369afbf7e00e5e778a6d089c7c28713da8eb81692525c849" => :high_sierra
  end

  depends_on "python@3.9"
  depends_on "xz"

  conflicts_with "gdb", because: "both install include/gdb, share/gdb and share/info"
  conflicts_with "i386-elf-gdb", because: "both install include/gdb, share/gdb and share/info"

  # Fix for Python 3.9, remove in next version
  # https://sourceware.org/pipermail/gdb-patches/2020-May/169110.html
  patch do
    url "https://github.com/Homebrew/formula-patches/raw/88f56f8f/gdb/python39.diff"
    sha256 "19e989104f54c09a30f06aac87e31706f109784d3e0fdc7ff0fd1bcfd261ebee"
  end

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
