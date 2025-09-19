class Uftrace < Formula
  desc "Function graph tracer for C/C++/Rust"
  homepage "https://uftrace.github.io/slide/"
  url "https://github.com/namhyung/uftrace/archive/refs/tags/v0.18.1.tar.gz"
  sha256 "c089e7f38dab8d17346d41cee0ec69dc60699d5527b54e6765712235577da0db"
  license "GPL-2.0-only"
  head "https://github.com/namhyung/uftrace.git", branch: "master"

  bottle do
    sha256 arm64_linux:  "39854e4f1aec61dcadecca292ba48f3206eec1f410296753652fd11e27232f0b"
    sha256 x86_64_linux: "ff78ccceb477a3c9d1743442323f61a3abd2c540a779a967cd0a47e7b0d843d3"
  end

  depends_on "pandoc" => :build
  depends_on "pkgconf" => :build
  depends_on "capstone"
  depends_on "elfutils"
  depends_on "libunwind"
  depends_on :linux
  depends_on "luajit"
  depends_on "ncurses"
  depends_on "python@3.13"

  def install
    # TODO: Obsolete with git master, to be removed when updating to next release
    inreplace "misc/version.sh", "deps/have_libpython2.7", "deps/have_libpython*"

    python3 = "python3.13"
    pyver = Language::Python.major_minor_version python3
    # Help pkg-config find python as we only provide `python3-embed` for aliased python formula
    inreplace Dir["check-deps/Makefile{,.check}"], "pkg-config python3", "pkg-config python-#{pyver}"

    system "./configure", "--disable-silent-rules", *std_configure_args
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
