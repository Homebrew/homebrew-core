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
    sha256 cellar: :any,                 arm64_monterey: "d0f61470e9448357d6005f53f4811efa8e73a40039813f037752e661ca7b4a0a"
    sha256 cellar: :any,                 arm64_big_sur:  "ba69178dc1572eb4bef6046d29374df8bdecb7ca7e2ab70b01452a41f353c108"
    sha256 cellar: :any,                 monterey:       "b67ebcc24f477a50fa722d9615f6809c17b8ddf523acca1e9a2936ad4fc6b894"
    sha256 cellar: :any,                 big_sur:        "c35a0d7e353d54ddb2d71446706b75390144c3dd8e18a885ffe406bdb800c739"
    sha256 cellar: :any,                 catalina:       "4473f4285647119b02094748250a90f008e8ae1e5d56d5de33ef4637f3f92118"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aafb2a11c36d77b06308552e8397e7baac4c37835d4197afa5ee9f4be7b3dcad"
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
