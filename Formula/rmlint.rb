class Rmlint < Formula
  desc "Extremely fast tool to remove dupes and other lint from your filesystem"
  homepage "https://github.com/sahib/rmlint"
  url "https://github.com/sahib/rmlint/archive/v2.6.1.tar.gz"
  sha256 "b4de3de2f197b5978113eb9d013ee9890efbdf01ba739416255ecc2567199b81"

  bottle do
    cellar :any
    sha256 "a574a19f089e1a24168c57472e5c95993c6b7ab5c2990bb07dfa54ecdc94b291" => :sierra
    sha256 "5e1aad2bec7238f2087d3ac643a6e0dba2f2b58a0302bb88acda26e035e23f99" => :el_capitan
    sha256 "7e155b9753da549229811558e2b1914a5aeb8b95b85317804a81a7cab3eb3853" => :yosemite
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
