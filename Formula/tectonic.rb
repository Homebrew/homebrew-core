class Tectonic < Formula
  desc "Modernized, complete, self-contained TeX/LaTeX engine"
  homepage "https://tectonic-typesetting.github.io/"
  url "https://github.com/tectonic-typesetting/tectonic/archive/tectonic@0.1.17.tar.gz"
  sha256 "cbe2dcc2fd5c87a2e01643bb1d7cb8eb8bb4236832aaa39eedd7d334400d5adb"
  license "MIT"

  bottle do
    cellar :any
    sha256 "1e9b02aeac6b6a0737df7419cff2af5e80687fc221dbe94fb7b6b9fe3712b875" => :catalina
    sha256 "07ac31644c79d962c6b4ffca2289c0fddc12c9af96dfbb1819bc3aa588e1b10a" => :mojave
    sha256 "6aab84597f31b3c47b95274e9028996bea4d808408eeccaae0d3c1635aca2f47" => :high_sierra
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

    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.tex").write 'Hello, World!\bye'
    system bin/"tectonic", "-o", testpath, "--format", "plain", testpath/"test.tex"
    assert_predicate testpath/"test.pdf", :exist?, "Failed to create test.pdf"
    assert_match "PDF document", shell_output("file test.pdf")
  end
end
