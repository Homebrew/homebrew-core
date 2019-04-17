class Rmlint < Formula
  desc "Extremely fast tool to remove dupes and other lint from your filesystem"
  homepage "https://github.com/sahib/rmlint"
  url "https://github.com/sahib/rmlint/archive/v2.8.0.tar.gz"
  sha256 "196bb595ac4d3d1a76ed62542b7895bda1cea47f0f77483286b2dfc8fc797253"

  bottle do
    cellar :any
    rebuild 1
    sha256 "80bcba0458b5d698083d163c9830b1337ed34784a38e89c0d7df637ecdf30a45" => :mojave
    sha256 "fc3dff4f420008d8d29fb70d82bb8c28326e7d94ae58655e1a8e0c766f2735eb" => :high_sierra
    sha256 "1ecbb17a04c9a141761d60cb0bf80e6a4df9fdc60cb96be9dc6a8e27222984d3" => :sierra
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
    system "scons"
    bin.install "rmlint"
    man1.install "docs/rmlint.1.gz"
  end

  test do
    (testpath/"1.txt").write("1")
    (testpath/"2.txt").write("1")
    assert_match "# Duplicate(s):", shell_output("#{bin}/rmlint")
  end
end
