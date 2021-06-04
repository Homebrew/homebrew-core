class Tectonic < Formula
  desc "Modernized, complete, self-contained TeX/LaTeX engine"
  homepage "https://tectonic-typesetting.github.io/"
  url "https://github.com/tectonic-typesetting/tectonic/archive/tectonic@0.4.1.tar.gz"
  sha256 "5a2c910f822d59ddaf9d32a0e5f7f34ce30f44e4129513b3a0c50425cf48ac8f"
  license "MIT"
  revision 2

  # As of writing, only the tags starting with `tectonic@` are release versions.
  # NOTE: The `GithubLatest` strategy cannot be used here because the "latest"
  # release on GitHub sometimes points to a tag that isn't a release version.
  livecheck do
    url :stable
    regex(/^tectonic@v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "f4c9848b087634dc44e65c279704735867c8cd9ceeaf1b223db5eb86d016931b"
    sha256 cellar: :any, big_sur:       "6e813d832a36c1bd5cbe050671195898c95b3c34693d7475335d01558ca99586"
    sha256 cellar: :any, catalina:      "3219998fb7f3cb1b9aeb56f28c2261259166356e6cf5a84224253edc442cc7cd"
    sha256 cellar: :any, mojave:        "ee346b94c8386bb0fe34983c55152761856ab695061f6d21d762a9b9fae8dcd3"
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
