class Tectonic < Formula
  desc "Modernized, complete, self-contained TeX/LaTeX engine"
  homepage "https://tectonic-typesetting.github.io/"
  url "https://github.com/tectonic-typesetting/tectonic/archive/refs/tags/tectonic@0.17.0.tar.gz"
  sha256 "30adda98f67dd5389844f6023adeeb54b5475c17a54b777900644468fbc9765d"
  license "MIT"
  revision 1
  head "https://github.com/tectonic-typesetting/tectonic.git", branch: "master"

  # As of writing, only the tags starting with `tectonic@` are release versions.
  # NOTE: The `GithubLatest` strategy cannot be used here because the "latest"
  # release on GitHub sometimes points to a tag that isn't a release version.
  livecheck do
    url :stable
    regex(/^tectonic@v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "cd5a512ed939507f6792f2e762a0135e47bcef6b92a972bc1d10222376f8d511"
    sha256 cellar: :any, arm64_tahoe:       "c29a2920a91b0a4db3f3d70026d45ff62e9328dc003df2399bddf2f3beadfdfc"
    sha256 cellar: :any, arm64_sequoia:     "37afa7011a76f2f2a44701c439f08593dba885a6d77c613ca1d8d1e0e4e13aa2"
    sha256 cellar: :any, arm64_linux:       "43f2d25a37bfff6e5911ff2c543b9943e7915d207c695d59f3eb40d8df7b7451"
    sha256 cellar: :any, x86_64_linux:      "17173ccaee1130ee6c92151bbddca0417e79e0e8d326f871cb76885f919ac805"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "freetype"
  depends_on "graphite2"
  depends_on "harfbuzz"
  depends_on "icu4c@79"
  depends_on "libpng"

  on_linux do
    depends_on "fontconfig"
    depends_on "openssl@4"
    depends_on "zlib-ng-compat"
  end

  # `test do` block downloads a TeX bundle
  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version.to_s if OS.mac? # needed for CLT-only builds

    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4") if OS.linux?

    system "cargo", "install", *std_cargo_args(features: "external-harfbuzz")
    bin.install_symlink bin/"tectonic" => "nextonic"
  end

  test do
    (testpath/"test.tex").write 'Hello, World!\bye'
    system bin/"tectonic", "-o", testpath, "--format", "plain", testpath/"test.tex"
    assert_path_exists testpath/"test.pdf", "Failed to create test.pdf"
    assert_match "PDF document", shell_output("file test.pdf")

    system bin/"nextonic", "new", "."
    system bin/"nextonic", "build"
    assert_path_exists testpath/"build/default/default.pdf", "Failed to create default.pdf"
  end
end
