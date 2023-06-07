class Tectonic < Formula
  desc "Modernized, complete, self-contained TeX/LaTeX engine"
  homepage "https://tectonic-typesetting.github.io/"
  url "https://github.com/tectonic-typesetting/tectonic/archive/tectonic@0.13.1.tar.gz"
  sha256 "bc16c2d7c85b646f5d168371a6cf1f2c219d8fcdcc919addcc9d74ce0cfbd442"
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
    sha256 cellar: :any,                 arm64_ventura:  "59233a41111742006cfe217decf8e6a9dcb04415d11f17062846cbb5d876b75b"
    sha256 cellar: :any,                 arm64_monterey: "1c6fb3dd606311cfa6efa570d4cd0480da8a44bb03072726f9c08cf08a3e128b"
    sha256 cellar: :any,                 arm64_big_sur:  "09c0185594df40590aa731e8983d2c1edacabc65a16135d0007cfaf6a4fe5f1e"
    sha256 cellar: :any,                 ventura:        "914e98a0119c5b3d35984021f87f36be0d4fae7a10a81f32ae530bfe2691531c"
    sha256 cellar: :any,                 monterey:       "ab203a09e142994f396bdfececa4c14ee2bd7563028b8432d3e24f8fcf566cc1"
    sha256 cellar: :any,                 big_sur:        "c25b82f042ab984e6ad20ce183166203f375e1ee8fb31488f0f876d4490be2cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4f5669288baaa9f87a589a2c60925072571bf9c87bba70a812a4a5be821e5c4"
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
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version.to_s # needed for CLT-only builds
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
