class Riscv64ElfGdb < Formula
  desc "GNU debugger for riscv64-elf cross development"
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
    sha256 arm64_sonoma:   "69e827ae4d9fb2557b7a0633b8fd465a8865f6c4f6368c06ab523f966a4d22fb"
    sha256 arm64_ventura:  "b730c8115a9690e20c5e1c98c65d54098a786aabb522ef0e7fc05d369bcc368f"
    sha256 arm64_monterey: "3ea7e8dd30bc0201ff6e193f36a2e393d62c279d7b18d93827ab6e789bf4e16f"
    sha256 sonoma:         "98ef12be27a6faeb51b4e17a678f32c0efd916583669b9154dee85f7369fe2a9"
    sha256 ventura:        "37720faaae0e249d4277efc26bf009d4689bd25d1f77a1cde0a6ada1d82374da"
    sha256 monterey:       "75e0735658e3cc2a7ee2c12937c644f0eed406753bcaa28055f0bb48153daf2b"
    sha256 x86_64_linux:   "fe6e9f6868e419a65137cbc5f71de460657c53f424c45a704810013356291286"
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
