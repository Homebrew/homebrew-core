class Tectonic < Formula
  desc "Modernized, complete, self-contained TeX/LaTeX engine"
  homepage "https://tectonic-typesetting.github.io/"
  url "https://github.com/tectonic-typesetting/tectonic/archive/tectonic@0.7.1.tar.gz"
  sha256 "0082f3aca5e9e8cf827aacbe260383faf1e036d0e8d04a3aef11deeadfff2baf"
  license "MIT"

  # As of writing, only the tags starting with `tectonic@` are release versions.
  # NOTE: The `GithubLatest` strategy cannot be used here because the "latest"
  # release on GitHub sometimes points to a tag that isn't a release version.
  livecheck do
    url :stable
    regex(/^tectonic@v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "e25d8cbedaefa978556832e64b3bf943f7e0e8052ed313c129fac339e81225cc"
    sha256 cellar: :any,                 big_sur:       "86e8dc87ff7dca9d2ccfc10a8ec6ee78e37743be3d9cda3ff398816264fd5cf8"
    sha256 cellar: :any,                 catalina:      "ed6bdde2a3dd1a57fa7e2730844e21b4ffb90cf934976c1a86874b2b0282b814"
    sha256 cellar: :any,                 mojave:        "70b8b06aeb5b36c5b1e1820179d556f1eddce139d1e01ed44959b95d61a8893c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c62eb6bfb7a9776c9ba595f27b2c5bb1540abed3f5a1dfaf4f04137d717a5d73"
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
