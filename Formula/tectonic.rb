class Tectonic < Formula
  desc "Modernized, complete, self-contained TeX/LaTeX engine"
  homepage "https://tectonic-typesetting.github.io/"
  url "https://github.com/tectonic-typesetting/tectonic/archive/tectonic@0.8.2.tar.gz"
  sha256 "1f92a5ff25725a9a4c0eefd4ea306da1e63f57c40d4ceb0972c7e5bb73297b4f"
  license "MIT"

  # As of writing, only the tags starting with `tectonic@` are release versions.
  # NOTE: The `GithubLatest` strategy cannot be used here because the "latest"
  # release on GitHub sometimes points to a tag that isn't a release version.
  livecheck do
    url :stable
    regex(/^tectonic@v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a06aec2e27f5af7ca3a30a1025b81b31fc2795ffda02067e875ec91802a8aa47"
    sha256 cellar: :any,                 arm64_big_sur:  "6509b4602d5c88c76aeafd21fbe4388cf8c9e4fc61f7d728023f6be0f738b143"
    sha256 cellar: :any,                 monterey:       "9d692bcb0c0f9ba8dead33bff5ad2c0dfbf08c53c842a868d0dd6741eb35a438"
    sha256 cellar: :any,                 big_sur:        "999ea525a9e4c3de50dc6b499fc12ce1db804f3efb825bc2a542ead433707048"
    sha256 cellar: :any,                 catalina:       "0c8b62e289a7f4130c0e6624d0f1d80aa6a68c8b21d9ef58de378a05a5a144df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "954c799d377b17c2f6ec9571c4457e98c0e4150411c3f78f178b15b22a18a494"
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
