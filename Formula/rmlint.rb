class Rmlint < Formula
  desc "Extremely fast tool to remove dupes and other lint from your filesystem"
  homepage "https://github.com/sahib/rmlint"
  url "https://github.com/sahib/rmlint/archive/v2.9.0.tar.gz"
  sha256 "a2d26863e0018efad60f0b1123e7cffd8ef764c8fb574a7987a49260e4e51c8f"

  bottle do
    cellar :any
    sha256 "ed346f576ec02c98e54c337e0370bb3b238abc0ccb90c84cd7d302ddd0d3713d" => :catalina
    sha256 "155767f2b4bc9d03e965f56e2dd6b9b8bd2cde55fb6fb553ce05a00fad35bd2a" => :mojave
    sha256 "9a05ea7f81263a7e2c0c6f2770b80ca942c92887906741dc3b8faba1d7a41d10" => :high_sierra
    sha256 "3c0e9d07bd06e4e9785dc54ccee7a7d0cdd2a95b2fe6a7ff0e12f66e1bbc0a6d" => :sierra
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
