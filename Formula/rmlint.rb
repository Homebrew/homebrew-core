class Rmlint < Formula
  desc "Extremely fast tool to remove dupes and other lint from your filesystem"
  homepage "https://github.com/sahib/rmlint"
  url "https://github.com/sahib/rmlint/archive/v2.7.0.tar.gz"
  sha256 "174aaf4a3fd4c2911b7ddffd2804c6b940e38bedbb5cf2a6ec51b552cf919c33"

  bottle do
    cellar :any
    sha256 "f58ccfb40457324cb15b72f044e6b469f70648fbdbe2a63010fe2c51110093ea" => :mojave
    sha256 "b5cfd1cc6f4c3aa2f548ac3afade8d120434de12b6499c8cd3e9e6b036225143" => :high_sierra
    sha256 "566dbc24b99002a0b07bfe991eb14969c003394bf027df247c640296e80dcc24" => :sierra
    sha256 "3e6f33d9e64a95fb88ed0a53397c2b2e0eb15fe73b33d6bea79cd2071826943a" => :el_capitan
  end

  option "with-json-glib", "Add support for reading json caches"
  option "with-libelf", "Add support for finding non-stripped binaries"

  depends_on "gettext" => :build
  depends_on "pkg-config" => :build
  depends_on "scons" => :build
  depends_on "sphinx-doc" => :build
  depends_on "glib"
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
