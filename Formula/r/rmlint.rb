class Rmlint < Formula
  desc "Extremely fast tool to remove dupes and other lint from your filesystem"
  homepage "https://rmlint.readthedocs.io/en/master/"
  url "https://github.com/sahib/rmlint/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "e7a20caf7f0162791f947a89931de76750daadd72be7719477278f3e949f00df"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "331ef960fb7ed5264bd9d46e6fe842e55954fcb3041070dcb66d26fa8a901a55"
    sha256 cellar: :any, arm64_tahoe:       "07f50ddbf1af0b241e62ec1e6c30015d1c795dcb57ea611f6fe7dbe1169e8112"
    sha256 cellar: :any, arm64_sequoia:     "db7662a9bb848c8d6d188fc2ef83f542647d26e35f77d942798303638b548b12"
    sha256 cellar: :any, arm64_linux:       "d0870c56ae57abb9f574ff7d1942bebfd496b8e50c0f742dfe152dde92f0162c"
    sha256 cellar: :any, x86_64_linux:      "1b168c4c73c3ee1ce1f35494e8f8d8f7d47f36a35c8b65959f2d77a4162cbf79"
  end

  depends_on "gettext" => :build
  depends_on "pkgconf" => :build
  depends_on "scons" => :build
  depends_on "sphinx-doc" => :build
  depends_on "glib"
  depends_on "json-glib"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "elfutils"
    depends_on "util-linux"
  end

  deny_network_access!

  def install
    if OS.linux?
      ENV.append_to_cflags "-I#{formula_opt_include("util-linux")}"
      ENV.append_to_cflags "-I#{formula_opt_include("elfutils")}"
      ENV.append "LDFLAGS", "-Wl,-rpath=#{formula_opt_lib("elfutils")}"
      ENV.append "LDFLAGS", "-Wl,-rpath=#{formula_opt_lib("glib")}"
      ENV.append "LDFLAGS", "-Wl,-rpath=#{formula_opt_lib("json-glib")}"
      ENV.append "LDFLAGS", "-Wl,-rpath=#{formula_opt_lib("util-linux")}"
    end

    system "scons", "--without-gui"
    bin.install "rmlint"
    man1.install "docs/_build/man/rmlint.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rmlint --version 2>&1")

    files = testpath/"files"
    files.mkpath
    (files/"first.txt").write("duplicate")
    (files/"second.txt").write("duplicate")
    (files/"unique.txt").write("unique")
    output = shell_output("#{bin}/rmlint -T df -o json:stdout #{files}")
    duplicates = JSON.parse(output)[1...-1]
    assert_equal %w[first.txt second.txt].map { |name| (files/name).to_s }.sort,
                 duplicates.map { |entry| entry.fetch("path") }.sort
  end
end
