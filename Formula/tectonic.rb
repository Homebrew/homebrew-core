class Tectonic < Formula
  desc "Modernized, complete, self-contained TeX/LaTeX engine"
  homepage "https://tectonic-typesetting.github.io/"
  url "https://github.com/tectonic-typesetting/tectonic/archive/tectonic@0.8.2.tar.gz"
  sha256 "1f92a5ff25725a9a4c0eefd4ea306da1e63f57c40d4ceb0972c7e5bb73297b4f"
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
    sha256 cellar: :any,                 arm64_monterey: "be507de3cd9b77fa2ab5c7677189d9687b5b3392a9bf916be6eeed8bb35bb7e1"
    sha256 cellar: :any,                 arm64_big_sur:  "dc5cfda9a86fea4223ac45436d11cf2b2adee281070d7cf99c04defeec92ffc5"
    sha256 cellar: :any,                 monterey:       "68665b117fdd0961964057692c9eeb47acb272f9cc7a7198ff890208752bb41f"
    sha256 cellar: :any,                 big_sur:        "d932309d51b4e1322746a81d5d4d0dab1efc4c856dc494a1791cb7711461a030"
    sha256 cellar: :any,                 catalina:       "afb3e78a43a2d9d044845bba81ec50f2b66d04b3847de9c028db48af805f0ed5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ddf29581458963094ee3f25b53a13bccd6a82e3f48f3a7e94fd95cab664fc96"
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
