class Rmlint < Formula
  desc "Extremely fast tool to remove dupes and other lint from your filesystem"
  homepage "https://github.com/sahib/rmlint"
  url "https://github.com/sahib/rmlint/archive/v2.4.5.tar.gz"
  sha256 "33a7c1755957572976caf33f413cda02e67b55089843ef0d7305fa496f79cfff"

  bottle do
    cellar :any
    sha256 "b1c74f7d57579329a5cf8009a86ca4ea6dcd95bdc0c5cee30a97bf6b2b3b5a67" => :sierra
    sha256 "70519bac667bf7dcf1b152e9b3cf6855079f8f5882e1cb96ed97381068adbe3a" => :el_capitan
    sha256 "4579a1094ca56ab3677b20b37e9c62a2ce27a641890360ca8d2153e5bfe119c0" => :yosemite
  end

  option "with-json-glib", "Add support for reading json caches"
  option "with-libelf", "Add support for finding non-stripped binaries"

  depends_on "glib" => :run
  depends_on "gettext" => :build
  depends_on "pkg-config" => :build
  depends_on "scons" => :build
  depends_on "sphinx-doc" => :build
  depends_on "json-glib" => :optional
  depends_on "libelf" => :optional

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
