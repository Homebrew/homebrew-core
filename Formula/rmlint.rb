class Rmlint < Formula
  desc "Extremely fast tool to remove dupes and other lint from your filesystem"
  homepage "https://github.com/sahib/rmlint"
  url "https://github.com/sahib/rmlint/archive/v2.6.1.tar.gz"
  sha256 "b4de3de2f197b5978113eb9d013ee9890efbdf01ba739416255ecc2567199b81"

  bottle do
    cellar :any
    sha256 "b0142574b59006f3d3ae016b6363d7b87b4917ca4cdc202f4e5443ce7cf7cb53" => :sierra
    sha256 "8647c0f86fcc225041895f24d97b582e9fe5c2591c0c79c29aad80c4ba8cf0c9" => :el_capitan
    sha256 "24486e319f4f82bbf7acb6ea63a6d699dbcfba094192fa5fc035959f5d243a50" => :yosemite
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
