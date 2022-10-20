class Tectonic < Formula
  desc "Modernized, complete, self-contained TeX/LaTeX engine"
  homepage "https://tectonic-typesetting.github.io/"
  url "https://github.com/tectonic-typesetting/tectonic/archive/tectonic@0.11.0.tar.gz"
  sha256 "7bdd4b4b18af2bd6c127ab03e1abf3088ac2e3b5471467387bd60620331eab4d"
  license "MIT"
  head "https://github.com/tectonic-typesetting/tectonic.git", branch: "master"

  # As of writing, only the tags starting with `tectonic@` are release versions.
  # NOTE: The `GithubLatest` strategy cannot be used here because the "latest"
  # release on GitHub sometimes points to a tag that isn't a release version.
  livecheck do
    url :stable
    regex(/^tectonic@v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e854eaca7cb31e9a55e00ab2f4ab5bdb3718eaa391b15638dfbda0f12c7141e0"
    sha256 cellar: :any,                 arm64_big_sur:  "1b9a29869eaffc1c81d863e776f7302959143b6289449564eb51e2f1e5b4f84a"
    sha256 cellar: :any,                 monterey:       "a8d4538dba93917b747ea63347e7642afc882525445b285c886280aed56dcae8"
    sha256 cellar: :any,                 big_sur:        "3a2671089b2579b745142bd8c9a6062cc2237d3a8bde2e1fe311cc53e82e1ba6"
    sha256 cellar: :any,                 catalina:       "9695850333257bdeb30025d695cf9371de410de76bf45908bec016bd3d419a61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3db817571afbe94612c7d15cf214c19c54d9058a790353046b256681e9a69c39"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "freetype"
  depends_on "graphite2"
  depends_on "harfbuzz"
  depends_on "icu4c"
  depends_on "libpng"
  depends_on "openssl@1.1"

  def install
    ENV.cxx11
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version # needed for CLT-only builds
    ENV.delete("HOMEBREW_SDKROOT") if MacOS.version == :high_sierra

    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix

    system "cargo", "install", "--features", "external-harfbuzz", *std_cargo_args
  end

  test do
    (testpath/"test.tex").write 'Hello, World!\bye'
    system bin/"tectonic", "-o", testpath, "--format", "plain", testpath/"test.tex"
    assert_predicate testpath/"test.pdf", :exist?, "Failed to create test.pdf"
    assert_match "PDF document", shell_output("file test.pdf")
  end
end
