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
    sha256 cellar: :any, arm64_golden_gate: "33c055a3a94b0b37f747dca29d57df64874fa874541c77ae889fdbde6ae37df6"
    sha256 cellar: :any, arm64_tahoe:       "306cae677bbe62d270d3a774dc0311726619c08765782493755e61f32f9a1804"
    sha256 cellar: :any, arm64_sequoia:     "b12e7b8260d56a20e726e7a17bd1b9d0df1497e08b4e389fd09c41d00ecd1cc7"
    sha256 cellar: :any, arm64_linux:       "c5078e4c8e721b4f61c603f6c182b871dc5bc77d0733a4f02709e77c9f91f48a"
    sha256 cellar: :any, x86_64_linux:      "68b31b599b77c5effd6eab4eaace8ccb4d6d4ad409fd830be985e978ee3a5296"
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
