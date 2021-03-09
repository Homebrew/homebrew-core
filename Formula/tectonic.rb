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
    sha256 cellar: :any, arm64_big_sur: "ca6e5d2c0f438d8ab645cb3a910a69b353d2ec1db75166109d8ea8dc0e68a47e"
    sha256 cellar: :any, big_sur:       "fc5ee56b319d0fface7d033aa0cdaf9e17f8a738e031dae4268d8b3a13b04493"
    sha256 cellar: :any, catalina:      "061da8046e4dad195200c34cf24916ec1171dd283be4df0fd6a74d56384ad00e"
    sha256 cellar: :any, mojave:        "44cf87fc25c63521b4338916d4caccf4edf7204b050d7a096c7a05c1aa7206f3"
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
