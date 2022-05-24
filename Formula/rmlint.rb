class Rmlint < Formula
  desc "Extremely fast tool to remove dupes and other lint from your filesystem"
  homepage "https://github.com/sahib/rmlint"
  url "https://github.com/sahib/rmlint/archive/v2.10.1.tar.gz"
  sha256 "10e72ba4dd9672d1b6519c0c94eae647c5069c7d11f1409a46e7011dd0c6b883"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "506515b8e54f1f0023c245b9dd52fa419cedbe5e2f8fb434b7991d49ad6e6dce"
    sha256 cellar: :any,                 arm64_big_sur:  "5eae37b1c416a95072b7475cffbbf5a8652c2f3f6c9e3d24b96c13b57ac06c24"
    sha256 cellar: :any,                 monterey:       "668514f9f5d6a28feb7bed3976b10a5daa51384e5e390664854f96f307be281a"
    sha256 cellar: :any,                 big_sur:        "ce229f94deeb1e91f84db64e71e4c3bd22f2bf0d1236c6093aad80d3685540b2"
    sha256 cellar: :any,                 catalina:       "b22e86d9727096bb5a73d92e28f03dcb36c7b46d4fbe3289a1105d46eff7d67b"
    sha256 cellar: :any,                 mojave:         "c31b3ec4510357b5acacf8469311faafb66725bc38d89938227903e33473dfd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02e65ca05dd6b4a94f0cf7d02affc88c757bfd52067698e3b4815d0a2813dced"
  end

  depends_on "gettext" => :build
  depends_on "pkg-config" => :build
  depends_on "scons" => :build
  depends_on "sphinx-doc" => :build
  depends_on "glib"
  depends_on "json-glib"

  on_linux do
    depends_on "elfutils"
    depends_on "util-linux"
  end

  def install
    if OS.linux?
      ENV.append_to_cflags "-I#{Formula["util-linux"].opt_include}"
      ENV.append_to_cflags "-I#{Formula["elfutils"].opt_include}"
      ENV.append "LDFLAGS", "-Wl,-rpath=#{Formula["elfutils"].opt_lib}"
      ENV.append "LDFLAGS", "-Wl,-rpath=#{Formula["glib"].opt_lib}"
      ENV.append "LDFLAGS", "-Wl,-rpath=#{Formula["json-glib"].opt_lib}"
      ENV.append "LDFLAGS", "-Wl,-rpath=#{Formula["util-linux"].opt_lib}"
    end

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
