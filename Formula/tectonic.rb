class Tectonic < Formula
  desc "Modernized, complete, self-contained TeX/LaTeX engine"
  homepage "https://tectonic-typesetting.github.io/"
  url "https://github.com/tectonic-typesetting/tectonic/archive/tectonic@0.9.0.tar.gz"
  sha256 "a239ca85bff1955792b2842fabfa201ba9576d916ece281278781f42c7547b9f"
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
    sha256 cellar: :any,                 arm64_monterey: "319706ab6f795fec741e4e8bd9f5eda2121a7880132bae889103fad1df9c67b6"
    sha256 cellar: :any,                 arm64_big_sur:  "01cd7f0fe959558b3a5987e6e03eb36bd95dcbc559adf04a90046157aa56e18e"
    sha256 cellar: :any,                 monterey:       "2de21af9446b85892a265021e2e54c9358b064ea2ee2673446d251b89a5b1860"
    sha256 cellar: :any,                 big_sur:        "36a7acbb55e4583971eb8d5130032de6603eaab0b739e0f261421ab9e13396fc"
    sha256 cellar: :any,                 catalina:       "5081fe3823fd982903e1dee4f8e309856e018ed7a60e37de0b99db4de62ff3e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32842c8098dda6c99b1f9b230e4f70d7a817e3dc3cff8cf5add2cf9b20ee3ce4"
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
