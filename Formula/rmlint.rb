class Rmlint < Formula
  desc "Extremely fast tool to remove dupes and other lint from your filesystem"
  homepage "https://github.com/sahib/rmlint"
  url "https://github.com/sahib/rmlint/archive/v2.4.6.tar.gz"
  sha256 "1ec614c38dbeb0a5d181286111ed4e37707fcd10e2c3569db0a41ef1765c5415"

  bottle do
    cellar :any
    sha256 "8cf75058b4f8da4574423411c016fc97a99c5fea11fc81def55a669603dc5956" => :sierra
    sha256 "c4c54070aa79e8a909af6c485c3218e7c99e61390829cfa20509b18dd6ec5468" => :el_capitan
    sha256 "706c793953814fff641d3415b5463337c32d35fae4e9e72d7b2ab80a9dca203f" => :yosemite
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
