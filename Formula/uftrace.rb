class Uftrace < Formula
  desc "Function graph tracer for C/C++/Rust"
  homepage "https://uftrace.github.io/slide/"
  url "https://github.com/namhyung/uftrace/archive/v0.10.tar.gz"
  sha256 "b8b56d540ea95c3eafe56440d6a998e0a140d53ca2584916b6ca82702795bbd9"
  license "GPL-2.0-only"
  head "https://github.com/namhyung/uftrace.git", branch: "master"

  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "capstone"
  depends_on "elfutils"
  depends_on "libunwind"
  depends_on :linux
  depends_on "ncurses"
  depends_on "python@3.9"

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install", "V=1"
  end

  test do
    out = shell_output("#{bin}/uftrace -A . -R . -P main #{bin}/uftrace -V")
    assert_match "dynamic", out
    assert_match "| main() {", out
    assert_match "printf", out
    assert_match "} /* main */", out
  end
end
