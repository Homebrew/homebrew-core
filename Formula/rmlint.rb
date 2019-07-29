class Rmlint < Formula
  desc "Extremely fast tool to remove dupes and other lint from your filesystem"
  homepage "https://github.com/sahib/rmlint"
  url "https://github.com/sahib/rmlint/archive/v2.8.0.tar.gz"
  sha256 "196bb595ac4d3d1a76ed62542b7895bda1cea47f0f77483286b2dfc8fc797253"
  revision 1

  bottle do
    cellar :any
    sha256 "552eeef7ab480b1a69fb3edbf9b7f05d7a267c732821ecc157f4faa422cee68b" => :mojave
    sha256 "8ea97a4b0511e8284ec45c4f9fdc8e52a1a7166c432ca572b42ac8c1e51c3c30" => :high_sierra
    sha256 "dc10a001e94ed01f24d6b7c60eabb981f3c04dabef0943090b5f77fcb0f136ae" => :sierra
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
