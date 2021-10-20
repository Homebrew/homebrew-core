class Uftrace < Formula
  desc "Function graph tracer for C/C++/Rust"
  homepage "https://uftrace.github.io/slide/"
  url "https://github.com/namhyung/uftrace/archive/v0.11.tar.gz"
  sha256 "101dbb13cb3320ee76525ec26426f2aa1de4e3ee5af74f79cb403ae4d2c6c871"
  license "GPL-2.0-only"
  head "https://github.com/namhyung/uftrace.git", branch: "master"

  bottle do
    sha256 x86_64_linux: "fda68417a3d5d9d6fd5f961a38f76757b43e634d2b7ebdaac02c81046f985de7"
  end

  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "capstone"
  depends_on "elfutils"
  depends_on "libunwind"
  depends_on :linux
  depends_on "luajit-openresty"
  depends_on "ncurses"
  depends_on "python@3.9"

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
