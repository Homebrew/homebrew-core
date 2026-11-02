class Rmlint < Formula
  desc "Extremely fast tool to remove dupes and other lint from your filesystem"
  homepage "https://rmlint.readthedocs.io/en/master/"
  url "https://github.com/sahib/rmlint/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "e7a20caf7f0162791f947a89931de76750daadd72be7719477278f3e949f00df"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "16f7480d4c138e0258da076c1321d3e2070c8a8005824ae4bfc75906a077fe49"
    sha256 cellar: :any, arm64_tahoe:       "84869952b1c95f0507c0faabed226bc17f4533da1f0fd861a64d04b4a96a1892"
    sha256 cellar: :any, arm64_sequoia:     "46ca694d9c24978245a0c211c945579c46d222ab4dbbea18dd5e60ac55054e77"
    sha256 cellar: :any, arm64_linux:       "5e01a4fba501524e4cc11d0015d0c39192331421fc79ccfcd80d18b8f2414375"
    sha256 cellar: :any, x86_64_linux:      "b38f17083790b4de85e0fc3abaa6e787ca626f8d0a78e3c68ca65986ee50e5e8"
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

  def install
    if OS.linux?
      ENV.append_to_cflags "-I#{formula_opt_include("util-linux")}"
      ENV.append_to_cflags "-I#{formula_opt_include("elfutils")}"
      ENV.append "LDFLAGS", "-Wl,-rpath=#{formula_opt_lib("elfutils")}"
      ENV.append "LDFLAGS", "-Wl,-rpath=#{formula_opt_lib("glib")}"
      ENV.append "LDFLAGS", "-Wl,-rpath=#{formula_opt_lib("json-glib")}"
      ENV.append "LDFLAGS", "-Wl,-rpath=#{formula_opt_lib("util-linux")}"
    end

    system "scons", "config"
    system "scons"
    bin.install "rmlint"
    man1.install "docs/_build/man/rmlint.1"
  end

  test do
    (testpath/"1.txt").write("1")
    (testpath/"2.txt").write("1")
    assert_match "# Duplicate(s):", shell_output(bin/"rmlint")
  end
end
