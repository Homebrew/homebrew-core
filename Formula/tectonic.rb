class Tectonic < Formula
  desc "Modernized, complete, self-contained TeX/LaTeX engine"
  homepage "https://tectonic-typesetting.github.io/"
  url "https://github.com/tectonic-typesetting/tectonic/archive/tectonic@0.8.0.tar.gz"
  sha256 "794cf34aee017b8a4288ed509a4e9d550a36aadc2bc0d35b1727d1135dac8e02"
  license "MIT"

  # As of writing, only the tags starting with `tectonic@` are release versions.
  # NOTE: The `GithubLatest` strategy cannot be used here because the "latest"
  # release on GitHub sometimes points to a tag that isn't a release version.
  livecheck do
    url :stable
    regex(/^tectonic@v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a34035a82dd65543d9b9151a961a381838ea51c30f1838d3bd8e2274441d5d78"
    sha256 cellar: :any,                 arm64_big_sur:  "c251b3e996a3a9bb92b4a3e01967a39a173d15953b24952b045a4bce12f5f5dd"
    sha256 cellar: :any,                 monterey:       "ca8640102fb480c90bd92652282d4865fea512c5a8e42c1a4dba9ef24f7aceac"
    sha256 cellar: :any,                 big_sur:        "f877391f52526e989cee32b8a6424a2c570c51c65f332134fb7fb94d11ede5f4"
    sha256 cellar: :any,                 catalina:       "90f93c343215ba86c8950e75309dbc241fe88ea25b3679c9c9c810bbc40ed198"
    sha256 cellar: :any,                 mojave:         "9efcd42f9b38b1d25f4144846ec107b6554be85dad65caf631da2923320be298"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ce6c644f17c8135cfcd0b83b7ba1d5320aca6d6a3acf1f3c558730c9abdd4c5"
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
