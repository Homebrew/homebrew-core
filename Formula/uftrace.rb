class Uftrace < Formula
  desc "Function graph tracer for C/C++/Rust"
  homepage "https://uftrace.github.io/slide/"
  url "https://github.com/namhyung/uftrace/archive/v0.11.tar.gz"
  sha256 "101dbb13cb3320ee76525ec26426f2aa1de4e3ee5af74f79cb403ae4d2c6c871"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/namhyung/uftrace.git", branch: "master"

  bottle do
    sha256 x86_64_linux: "d60b516de39225dd55aead6358ff5b9f51006ce2d47d51efe89e50d2b7aface1"
  end

  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "capstone"
  depends_on "elfutils"
  depends_on "libunwind"
  depends_on :linux
  depends_on "luajit-openresty"
  depends_on "ncurses"
  depends_on "python@3.10"

  def install
    # Obsolete with git master, to be removed when updating to next release
    inreplace "misc/version.sh", "deps/have_libpython2.7", "deps/have_libpython*"
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install", "V=1"
  end

  test do
    out = shell_output("#{bin}/uftrace -A . -R . -P main #{bin}/uftrace -V")
    assert_match "dwarf", out
    assert_match "python", out
    assert_match "luajit", out
    assert_match "tui", out
    assert_match "sched", out
    assert_match "dynamic", out

    assert_match "| main() {", out
    assert_match "|   getopt_long(2, ", out
    assert_match "printf", out
    assert_match "| } /* main */", out
  end
end
