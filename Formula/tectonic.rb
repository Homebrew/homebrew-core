class Tectonic < Formula
  desc "Modernized, complete, self-contained TeX/LaTeX engine"
  homepage "https://tectonic-typesetting.github.io/"
  url "https://github.com/tectonic-typesetting/tectonic/archive/tectonic@0.4.1.tar.gz"
  sha256 "5a2c910f822d59ddaf9d32a0e5f7f34ce30f44e4129513b3a0c50425cf48ac8f"
  license "MIT"
  revision 1

  # As of writing, only the tags starting with `tectonic@` are release versions.
  # NOTE: The `GithubLatest` strategy cannot be used here because the "latest"
  # release on GitHub sometimes points to a tag that isn't a release version.
  livecheck do
    url :stable
    regex(/^tectonic@v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "98a8197e79a15cbb27f29f871d78ef1ee3a5bff4292afd0aa030b12bc8d6e7bb" => :big_sur
    sha256 "8af05e3deffb86e2f2893b40692d5299bb66e323dc24a52277f605bb48274261" => :arm64_big_sur
    sha256 "ee982811abc9559c29b502bac4938342c7c8c6d707ca4d374b0d5cf39ee1d6a0" => :catalina
    sha256 "573741924359aa5859b481faa45c18956f00b9c5e865877da40f2d71ccafb868" => :mojave
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

    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.tex").write 'Hello, World!\bye'
    system bin/"tectonic", "-o", testpath, "--format", "plain", testpath/"test.tex"
    assert_predicate testpath/"test.pdf", :exist?, "Failed to create test.pdf"
    assert_match "PDF document", shell_output("file test.pdf")
  end
end
