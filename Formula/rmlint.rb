class Rmlint < Formula
  desc "Extremely fast tool to remove dupes and other lint from your filesystem"
  homepage "https://github.com/sahib/rmlint"
  url "https://github.com/sahib/rmlint/archive/v2.4.6.tar.gz"
  sha256 "1ec614c38dbeb0a5d181286111ed4e37707fcd10e2c3569db0a41ef1765c5415"

  bottle do
    cellar :any
    sha256 "906e04c346f1c20aa5f42aef75f45f76d758f8e7cb18b78178dbeb1a5b73a77a" => :sierra
    sha256 "5eaa91172e5d5580fad4b382182721704008bb20515965e57897486f6792100e" => :el_capitan
    sha256 "e1230b201afba08957e237a92e837933fd5b69b02705f1b5fde31fc88e9b7c4e" => :yosemite
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
