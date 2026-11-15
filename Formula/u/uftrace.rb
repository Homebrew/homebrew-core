class Uftrace < Formula
  desc "Function graph tracer for C/C++/Rust"
  homepage "https://uftrace.github.io/slide/"
  url "https://github.com/namhyung/uftrace/archive/refs/tags/v0.20.tar.gz"
  sha256 "03189061130693b274a4d0af47c4a3135d4a496ca111b78233593bfcb3d3720f"
  license "GPL-2.0-only"
  head "https://github.com/namhyung/uftrace.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_linux:  "e04804d875425f3f453095e2c140a25aebeaafcff91bdfd231324ab60789aaa0"
    sha256 x86_64_linux: "78c8aed953ac99083dc492732ec1ef46aa98fff8dfadb1eea858fe69e1f380f8"
  end

  depends_on "pandoc" => :build
  depends_on "pkgconf" => :build
  depends_on "capstone"
  depends_on "elfutils"
  depends_on "libunwind"
  depends_on :linux
  depends_on "luajit"
  depends_on "ncurses"
  depends_on "python@3.15"
  depends_on "xz"

  def install
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
