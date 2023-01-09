class Uftrace < Formula
  desc "Function graph tracer for C/C++/Rust"
  homepage "https://uftrace.github.io/slide/"
  url "https://github.com/namhyung/uftrace/archive/v0.13.tar.gz"
  sha256 "cffae82c68446c20cc3c7e87e71e57498805767a0d4085b4846f3c49f9e472d9"
  license "GPL-2.0-only"
  head "https://github.com/namhyung/uftrace.git", branch: "master"

  bottle do
    rebuild 1
    sha256 x86_64_linux: "aab9b83ddaf451b1982c0e03d7c3e19c06f563f2ba9831c4082787c6dc38d3c3"
  end

  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "capstone"
  depends_on "elfutils"
  depends_on "libunwind"
  depends_on :linux
  depends_on "luajit"
  depends_on "ncurses"
  depends_on "python@3.11"

  def install
    # TODO: Obsolete with git master, to be removed when updating to next release
    inreplace "misc/version.sh", "deps/have_libpython2.7", "deps/have_libpython*"

    python3 = "python3.11"
    pyver = Language::Python.major_minor_version python3
    # Help pkg-config find python as we only provide `python3-embed` for aliased python formula
    inreplace Dir["check-deps/Makefile{,.check}"], "pkg-config python3", "pkg-config python-#{pyver}"

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
