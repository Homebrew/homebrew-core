class Tectonic < Formula
  desc "Modernized, complete, self-contained TeX/LaTeX engine"
  homepage "https://tectonic-typesetting.github.io/"
  url "https://github.com/tectonic-typesetting/tectonic/archive/refs/tags/tectonic@0.14.1.tar.gz"
  sha256 "3703a4fc768b3c7be6a4560857b17b2671f19023faee414aa7b6befd24ec9d25"
  license "MIT"
  revision 2
  head "https://github.com/tectonic-typesetting/tectonic.git", branch: "master"

  # As of writing, only the tags starting with `tectonic@` are release versions.
  # NOTE: The `GithubLatest` strategy cannot be used here because the "latest"
  # release on GitHub sometimes points to a tag that isn't a release version.
  livecheck do
    url :stable
    regex(/^tectonic@v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "363db58c94cb0923160b9fa16986acc081368e281c7610ca1f031483a3e96df2"
    sha256 cellar: :any,                 arm64_ventura:  "5dd3b7db96ffab491041e106fb6dcf24d4ad712fe88be9279087aee97d5ad276"
    sha256 cellar: :any,                 arm64_monterey: "b0a9e5e898add71ffb50c91fd0279a5eabc9793bcd8afc4a2e26201953ee2d53"
    sha256 cellar: :any,                 arm64_big_sur:  "3a7793364b85c664b5468db12e3f7935330f586412a02a8fa25382c013aa018f"
    sha256 cellar: :any,                 sonoma:         "9c653f053d6aeb8909f83be87c47deec6af389fefb4ca028905f291c733d81f4"
    sha256 cellar: :any,                 ventura:        "c4b2e2e1cd05d771da209c2f413a2a88e7926f29ead6c41c8bbcc0aea98b96ba"
    sha256 cellar: :any,                 monterey:       "a7fac0a78531be18364818ef1f85355194b76afd61200cab12dc6113323f501c"
    sha256 cellar: :any,                 big_sur:        "73c54a7e44c9de3b426ed86ee5dec12926920ce04a03d832383606184b874c54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "795856c61ffe62b2ad8225252ecb5cac2eda7d14e395bf3d763370857acd1e0a"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "freetype"
  depends_on "graphite2"
  depends_on "harfbuzz"
  depends_on "icu4c"
  depends_on "libpng"
  depends_on "openssl@3"

  def install
    ENV.cxx11

    if OS.mac?
      ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version.to_s # needed for CLT-only builds
      ENV.delete("HOMEBREW_SDKROOT") if MacOS.version == :high_sierra
    end

    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

    system "cargo", "install", "--features", "external-harfbuzz", *std_cargo_args
  end

  test do
    (testpath/"test.tex").write 'Hello, World!\bye'
    system bin/"tectonic", "-o", testpath, "--format", "plain", testpath/"test.tex"
    assert_predicate testpath/"test.pdf", :exist?, "Failed to create test.pdf"
    assert_match "PDF document", shell_output("file test.pdf")
  end
end
