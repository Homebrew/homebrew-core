class X8664ElfGdb < Formula
  desc "GNU debugger for x86_64-elf cross development"
  homepage "https://www.gnu.org/software/gdb/"
  # Please add to synced_versions_formulae.json once version synced with gdb
  url "https://ftp.gnu.org/gnu/gdb/gdb-11.2.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-11.2.tar.xz"
  sha256 "1497c36a71881b8671a9a84a0ee40faab788ca30d7ba19d8463c3cc787152e32"
  license "GPL-3.0-or-later"
  head "https://sourceware.org/git/binutils-gdb.git", branch: "master"

  livecheck do
    formula "gdb"
  end

  bottle do
    sha256 arm64_monterey: "d081898aa072d34c2f85aba2c8c503a6800b5c4969158082ff4baa2ecd59c35d"
    sha256 arm64_big_sur:  "e50a7058eaf366351945bac53ab80ddd65aa442a070a7d6e03f643dc29d4fafb"
    sha256 monterey:       "488cccc9ca21e3a00578a0be4d391883f77f5ec3a438cad4102bac1c894cbd9f"
    sha256 big_sur:        "2abc758f2d837187ed5a8e74a1de4280a9911096d5af62d02eb7f3c8c33a2b1d"
    sha256 catalina:       "552b184fb25e04d6ec7496b0677cf68d40733ac4c839b64fb46128a8907e5505"
    sha256 x86_64_linux:   "759522a7eac37bde17932a7ae8112deab7aeca42763cc5323f81cabd92b5f068"
  end

  depends_on "x86_64-elf-gcc" => :test
  depends_on "gmp"
  depends_on "python@3.10"
  depends_on "xz"

  uses_from_macos "zlib"

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
      --with-python=#{which("python3")}
      --with-system-zlib
      --disable-binutils
    ]

    mkdir "build" do
      system "../configure", *args
      ENV.deparallelize # Error: common/version.c-stamp.tmp: No such file or directory
      system "make"
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
