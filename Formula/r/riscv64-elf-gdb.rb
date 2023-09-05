class Riscv64ElfGdb < Formula
  desc "GNU debugger for riscv64-elf cross development"
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
    sha256 arm64_ventura:  "903d1db714bcffec0b16ad4d64dc5f6081a28ece9d466b06effda5368e4204c1"
    sha256 arm64_monterey: "30a2b9905b314d1c6f97d8885be9994844691b3e5c39d2aa6560609149dc0954"
    sha256 arm64_big_sur:  "cce6901705f4677a8c12a351ad0418c6c07fb7c897cd4a4962529a1ebf70f582"
    sha256 ventura:        "be286dba7cbc64fc3f0e6421aa6332c51e134e01d2698ab58fc3ce8952533a08"
    sha256 monterey:       "9a7ab73441b8f898e6702bb5800be9562c67711d1e4497d5db486e9e67ef4fd4"
    sha256 big_sur:        "07daa45aad65a85168a581173b57399aa372c0eacb8370ae8c14d1ae59dfbc50"
    sha256 x86_64_linux:   "fc83ac581b46ef0844e492c96d6d8a27e37dcca381921103cf241ef5445a8066"
  end

  depends_on "riscv64-elf-gcc" => :test
  depends_on "gmp"
  depends_on "python@3.11"
  depends_on "xz" # required for lzma support

  uses_from_macos "zlib"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    target = "riscv64-elf"
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
    system "#{Formula["riscv64-elf-gcc"].bin}/riscv64-elf-gcc", "-g", "-nostdlib", "test.c"
    assert_match "Symbol \"_start\" is a function at address 0x",
          shell_output("#{bin}/riscv64-elf-gdb -batch -ex 'info address _start' a.out")
  end
end
