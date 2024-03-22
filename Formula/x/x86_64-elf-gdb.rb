class X8664ElfGdb < Formula
  desc "GNU debugger for x86_64-elf cross development"
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
    sha256 arm64_sonoma:   "65a80736adebfd37c8a295f8002d4f9e70da5d765d13cffd328632702683346a"
    sha256 arm64_ventura:  "2cbae118e4a1249aaa316657e42d484eed29da52dd631aac6fde1c979b53b0d8"
    sha256 arm64_monterey: "bc4ae34e3548fa909c1fbad2bf641d6fe3cf9071e4fe45cb91539919d29c99cc"
    sha256 sonoma:         "b0a03d97c2c8b50699ccac7e0643f5cc754e3dc0ea872efe76c3380ba211b0cd"
    sha256 ventura:        "868a9152559d068f26b97f577903729ad3e79c73ec56231b3104f5c8fecf9a0e"
    sha256 monterey:       "b151f15a335539b1f58e6bf4612dcfafb2bb247bc5982e6774d9cb33d3af708c"
    sha256 x86_64_linux:   "7337e8053ddf2ab47551f2146209fcbceda3890a6f0a7f4bfb78f74a9bfd269b"
  end

  depends_on "x86_64-elf-gcc" => :test
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "python@3.12"
  depends_on "xz" # required for lzma support

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
    assert_match "Symbol \"_start\" is a function at address 0x",
          shell_output("#{bin}/x86_64-elf-gdb -batch -ex 'info address _start' a.out")
  end
end
