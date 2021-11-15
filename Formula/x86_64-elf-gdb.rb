class X8664ElfGdb < Formula
  desc "GNU debugger for x86_64-elf cross development"
  homepage "https://www.gnu.org/software/gdb/"
  # Please add to synced_versions_formulae.json once version synced with gdb
  url "https://ftp.gnu.org/gnu/gdb/gdb-10.2.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-10.2.tar.xz"
  sha256 "aaa1223d534c9b700a8bec952d9748ee1977513f178727e1bee520ee000b4f29"
  license "GPL-3.0-or-later"
  revision 1
  head "https://sourceware.org/git/binutils-gdb.git", branch: "master"

  livecheck do
    formula "gdb"
  end

  bottle do
    sha256 arm64_monterey: "9e34d2e213705832ed1f5800868b1b4d0918054432806df08cd521d9dc98de1a"
    sha256 arm64_big_sur:  "c2ad5a848a586c732f9ef0d51c432a2606343336bafd226c909d832a66e63411"
    sha256 monterey:       "0aa2bd5bf04a3d2951b3b0591b87de5d2867e8704247672676b471eed16baf00"
    sha256 big_sur:        "5c67cee5589f207de3b521fea5b1805e717b5101bb95d335752e74250e520abf"
    sha256 catalina:       "9b795b9a0dfd2d16d96218650d55c4037c60631f90c2584300429d52273d352d"
    sha256 mojave:         "0b742041c90c670607311c303bf59f1aeb5517dc1573d8690564736b01dcbca1"
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
      --with-python=#{Formula["python@3.9"].opt_bin}/python3
      --with-system-zlib
      --disable-binutils
    ]

    mkdir "build" do
      system "../configure", *args
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
