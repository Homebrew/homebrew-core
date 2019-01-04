class Rmlint < Formula
  desc "Extremely fast tool to remove dupes and other lint from your filesystem"
  homepage "https://github.com/sahib/rmlint"
  url "https://github.com/sahib/rmlint/archive/v2.8.0.tar.gz"
  sha256 "196bb595ac4d3d1a76ed62542b7895bda1cea47f0f77483286b2dfc8fc797253"

  bottle do
    cellar :any
    sha256 "868fb80acb784a7634e5c7fe6e75cee86d4c93615213156f0d97a22c3e27d0e6" => :mojave
    sha256 "fa8f2ebb9224446dcf5dfbaca94f97bfe983a10888dd0d514345643c0394fd70" => :high_sierra
    sha256 "a0987dfb0b23a5e3f5a93bb93480834cdf2e54c046784af3ba2c191336905e88" => :sierra
  end

  depends_on "gettext" => :build
  depends_on "pkg-config" => :build
  depends_on "scons" => :build
  depends_on "sphinx-doc" => :build
  depends_on "glib"
  depends_on "json-glib"
  depends_on "libelf"

  def install
    system "scons", "config"
    scons
    bin.install "rmlint"
    man1.install "docs/rmlint.1.gz"
  end

  test do
    (testpath/"1.txt").write("1")
    (testpath/"2.txt").write("1")
    assert_match "# Duplicate(s):", shell_output("#{bin}/rmlint")
  end
end
