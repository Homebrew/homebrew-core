class X8664ElfGdb < Formula
  desc "GNU debugger for x86_64-elf cross development"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-15.2.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-15.2.tar.xz"
  sha256 "83350ccd35b5b5a0cba6b334c41294ea968158c573940904f00b92f76345314d"
  license "GPL-3.0-or-later"
  head "https://sourceware.org/git/binutils-gdb.git", branch: "master"

  livecheck do
    formula "gdb"
  end

  bottle do
    sha256 arm64_sequoia: "b4a37cc07ed4f167af859b14f5bbef1810d6da398c2950bfc4dbc229b660d603"
    sha256 arm64_sonoma:  "c2cfcaf13fb0a884526f28b1d3e5c003f434ceb32ebc763d5c93effd960b387f"
    sha256 arm64_ventura: "2aabe359b5ba0134d73be955a7acb49439c2a32cad29da4a3d2f5be748a87fed"
    sha256 sonoma:        "86aab0c249fae16a8ac42e32ee2b9b3e199c603eeb2e420ffbad806b22ca48d6"
    sha256 ventura:       "f49d50a7283884ac80ee9564e88abab5bd3dd367a84161bd56166e9f814834de"
    sha256 x86_64_linux:  "93c20ca8de2681ae1b9262d0c52831acce867060e19d2f936aa0487b96aad2ec"
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
