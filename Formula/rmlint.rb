class Rmlint < Formula
  desc "Extremely fast tool to remove dupes and other lint from your filesystem"
  homepage "https://github.com/sahib/rmlint"
  url "https://github.com/sahib/rmlint/archive/v2.10.1.tar.gz"
  sha256 "10e72ba4dd9672d1b6519c0c94eae647c5069c7d11f1409a46e7011dd0c6b883"
  license "GPL-3.0-or-later"

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
    # patch to address bug affecting High Sierra & Mojave introduced in rmlint v2.10.0
    # may be removed once the following issue / pull request are resolved & merged:
    #   https://github.com/sahib/rmlint/issues/438
    #   https://github.com/sahib/rmlint/pull/444
    if MacOS.version < :catalina
      inreplace "lib/cfg.c",
      "    rc = faccessat(AT_FDCWD, path, R_OK, AT_EACCESS|AT_SYMLINK_NOFOLLOW);",
      "    rc = faccessat(AT_FDCWD, path, R_OK, AT_EACCESS);"
    end

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
