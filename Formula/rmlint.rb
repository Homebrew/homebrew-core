class Rmlint < Formula
  desc "Extremely fast tool to remove dupes and other lint from your filesystem"
  homepage "https://github.com/sahib/rmlint"
  url "https://github.com/sahib/rmlint/archive/v2.10.1.tar.gz"
  sha256 "10e72ba4dd9672d1b6519c0c94eae647c5069c7d11f1409a46e7011dd0c6b883"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "4a8bd2357b069ad4be2327e14569931add4a6063f7642cc5a50ee0918e752362"
    sha256 cellar: :any, big_sur:       "1f6f76bfe7c4f4c058b91a0808e6e19a0029f4a4017929615bc223666abddf5a"
    sha256 cellar: :any, catalina:      "38f621eb2196afa5504087ef48cd19777efbd5da81302ea668b0efbd68cc20d7"
    sha256 cellar: :any, mojave:        "e7eac7ed5d93b19175c7860fe84faa34f878253c15bdbc280ee06cfd392f10e3"
    sha256 cellar: :any, high_sierra:   "b84e9cd89ef6b9d43f633226e0a7ecb85e5c75c65f3b50f83cf687862db8d191"
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
