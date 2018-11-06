class Rmlint < Formula
  desc "Extremely fast tool to remove dupes and other lint from your filesystem"
  homepage "https://github.com/sahib/rmlint"
  url "https://github.com/sahib/rmlint/archive/v2.8.0.tar.gz"
  sha256 "196bb595ac4d3d1a76ed62542b7895bda1cea47f0f77483286b2dfc8fc797253"

  bottle do
    cellar :any
    sha256 "d2bcfaf13a8efa184a21f1a1e3bb2aa6404e5910395318e618033b92f3502937" => :mojave
    sha256 "cb838927235a01faa66eae957cc2b6a3a03182e4d320e45fd2ecc85b04dc93e9" => :high_sierra
    sha256 "7471b380c8641f1ba9899d9bd672e52a3879de17218e72705acfc72c8b156214" => :sierra
  end

  depends_on "gettext" => :build
  depends_on "pkg-config" => :build
  depends_on "scons" => :build
  depends_on "sphinx-doc" => :build
  depends_on "glib"
  depends_on "json-glib"
  depends_on "libelf"

  def install
    scons "config"
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
