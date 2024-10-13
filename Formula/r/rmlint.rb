class Rmlint < Formula
  desc "Extremely fast tool to remove dupes and other lint from your filesystem"
  homepage "https://github.com/sahib/rmlint"
  url "https://github.com/sahib/rmlint/archive/refs/tags/v2.10.2.tar.gz"
  sha256 "0a0233ad517e0fb721f21e188a57cdee5279dd5329b38acb56d5d5312ce46388"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "078bb44e98c88380cea69407a81edbee8f579718ce0610d4dc1c0d194a74909f"
    sha256 cellar: :any,                 arm64_sonoma:   "e0230b688d4affb228e377a0c26b0d5d32b00ac520c67f8c0a125638be50927d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b150afab45efddb5b6df4ea0e31698447aa772a9ffa4979d3af991723477fa54"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd0d1429fee2937667a3bfeefa62afa4d1844295c728e018a6aa73161bba365a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "89d78b6e1b503c1a3392085e00eff9b757285c1404ae0d48b9152536b40bae48"
    sha256 cellar: :any,                 sonoma:         "7800b37fe7f0448ac5fe34ebf266e0957b1c42f308c844e42b442b0a9d7b1bd0"
    sha256 cellar: :any_skip_relocation, ventura:        "6f0ce088122c58e5a26e0d8f11781c08cb8e08eee08562b3a2010b345975a724"
    sha256 cellar: :any_skip_relocation, monterey:       "d261d543a78134d20476c58bf77c7f8d11523205c238ec128a4bba212ef141bb"
    sha256 cellar: :any_skip_relocation, big_sur:        "380c6d02cfafea119241c0bd887e147b049179ac16f3b08cc4dc419c882105db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f056030634c596f3880dcc9b97e71fea6ebf1a556daad25c1907f2e6ab41eeb"
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

    system "scons", "config"
    system "scons"
    bin.install "rmlint"
    man1.install "docs/rmlint.1.gz"
  end

  test do
    (testpath/"1.txt").write("1")
    (testpath/"2.txt").write("1")
    assert_match "# Duplicate(s):", shell_output(bin/"rmlint")
  end
end
