class Tectonic < Formula
  desc "Modernized, complete, self-contained TeX/LaTeX engine"
  homepage "https://tectonic-typesetting.github.io/"
  url "https://github.com/tectonic-typesetting/tectonic/archive/tectonic@0.4.1.tar.gz"
  sha256 "5a2c910f822d59ddaf9d32a0e5f7f34ce30f44e4129513b3a0c50425cf48ac8f"
  license "MIT"

  bottle do
    cellar :any
    sha256 "09e69c2d2e59ecc4d51341f232d3413302ff13f2f4af991f2ca5a9605b1d3740" => :big_sur
    sha256 "07715970c795bd46c90032cbc9698f14b125b8a6d8e710408b8ae02f08c22f6c" => :arm64_big_sur
    sha256 "22b064c27271ef786660c3269f867f2540dd72ae3e7868a72b4efa9dbea727c0" => :catalina
    sha256 "9a80916a07d052d35f48ac6ed2600dfa240d1bf16ab89fb30cf99dba671889b0" => :mojave
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
