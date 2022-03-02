class Tectonic < Formula
  desc "Modernized, complete, self-contained TeX/LaTeX engine"
  homepage "https://tectonic-typesetting.github.io/"
  url "https://github.com/tectonic-typesetting/tectonic/archive/tectonic@0.8.2.tar.gz"
  sha256 "1f92a5ff25725a9a4c0eefd4ea306da1e63f57c40d4ceb0972c7e5bb73297b4f"
  license "MIT"

  # As of writing, only the tags starting with `tectonic@` are release versions.
  # NOTE: The `GithubLatest` strategy cannot be used here because the "latest"
  # release on GitHub sometimes points to a tag that isn't a release version.
  livecheck do
    url :stable
    regex(/^tectonic@v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c7e1f0e651a721c43bc1df971b45132180bab93aa48d3ff9b845f4391185f4e8"
    sha256 cellar: :any,                 arm64_big_sur:  "76da980a13941facca2b98cc4d51982d8db863ac86ec682768dd1d45662589fa"
    sha256 cellar: :any,                 monterey:       "be820fddf8b1da011dae5be020b02906a544504d95696837338ed8d346f74a8b"
    sha256 cellar: :any,                 big_sur:        "f16ded1a0174bc131c62b801bdeb3a38a1c9bb7a5abb5794408f3d77d9ab8935"
    sha256 cellar: :any,                 catalina:       "b4b48e7c3011abc39cc610854bac545789f4ce6a51d77687161a4789c994c395"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e55a03c85b049398dd697b9f304bcab27c53f85deb859b21bb647c24d537d9e7"
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
