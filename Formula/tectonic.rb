class Tectonic < Formula
  desc "Modernized, complete, self-contained TeX/LaTeX engine"
  homepage "https://tectonic-typesetting.github.io/"
  url "https://github.com/tectonic-typesetting/tectonic/archive/tectonic@0.12.0.tar.gz"
  sha256 "96a53ab5ba29d2bf263f19b6f07450471118bf2067c610b362a1492d0b9b989f"
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
    sha256 cellar: :any,                 arm64_ventura:  "125ae7437cb1e2af6a9f79db285e0bbe8c7e5c0ce96045705525859e41d906d5"
    sha256 cellar: :any,                 arm64_monterey: "502d74dc17414cdce878ec9cb8300f6facf0872942f83e566b1d1053e0f7ea3a"
    sha256 cellar: :any,                 arm64_big_sur:  "37c727c4739e728937e636f62aaa8185e81145a6721ba10e6cffb9cd6e08ea94"
    sha256 cellar: :any,                 ventura:        "50840182fba623f9780bcb8f5343fb359235fc73b1891a6fceb21fa68e730085"
    sha256 cellar: :any,                 monterey:       "470d6e7cfe93b7c7385e36d1f747c77985cb83302eb43c8f179a1be4e0e72792"
    sha256 cellar: :any,                 big_sur:        "3713f373c74b0803fe1f35277cb28331f237c6b47c47f5ba928e5b197062cc79"
    sha256 cellar: :any,                 catalina:       "c6729ef8f16818c0ec21e5fac851bad7551f189c105acc35c25690af8551a13d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed46d97a00754f3182a79d710900a397ea59d0e5cd624c7cd86dc08fa54c9627"
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
