class Tectonic < Formula
  desc "Modernized, complete, self-contained TeX/LaTeX engine"
  homepage "https://tectonic-typesetting.github.io/"
  url "https://github.com/tectonic-typesetting/tectonic/archive/refs/tags/tectonic@0.16.8.tar.gz"
  sha256 "7ca10b83b9c48f9b0907db32bb04b44cf778599c23bd2a45836bd39e27630535"
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
    sha256 cellar: :any,                 arm64_tahoe:   "6b5b6f11551231badfce531e420ee080c235a16a94cea6e148acd8df1e42a94d"
    sha256 cellar: :any,                 arm64_sequoia: "d24b80f7fc9394a2c1716614db8ff00dea6d6c4011503279311d3d6a297ed40f"
    sha256 cellar: :any,                 arm64_sonoma:  "2aff9783132f6563fb3006f1dcc6105e68a1ab0482d2257f03052686b8264830"
    sha256 cellar: :any,                 sonoma:        "493a6ba416c3183e2c4fc73ba4191fd5aebba3778a9acb6959bd6399833e68fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "695409a79fb50225c634ea2d3021842dcad683df46fa39902b80bbb1dcf3b274"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa17b1457469827e1a64d694a937f916da035db47596a57f971cba1f6212c7ee"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "freetype"
  depends_on "graphite2"
  depends_on "harfbuzz"
  depends_on "icu4c@78"
  depends_on "libpng"
  depends_on "openssl@3"

  on_linux do
    depends_on "fontconfig"
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version.to_s if OS.mac? # needed for CLT-only builds

    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

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
