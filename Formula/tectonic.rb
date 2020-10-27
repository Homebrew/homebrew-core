class Tectonic < Formula
  desc "Modernized, complete, self-contained TeX/LaTeX engine"
  homepage "https://tectonic-typesetting.github.io/"
  url "https://github.com/tectonic-typesetting/tectonic/archive/tectonic@0.2.0.tar.gz"
  sha256 "fce39a26b8a88c662de114ce38f407f234e255c4cef6ea825e85358e936b9bbd"
  license "MIT"

  bottle do
    cellar :any
    sha256 "acbf81226ecd0690f80e2715e2f726647ccc1418e9ab75efaf8ca660d6866a74" => :catalina
    sha256 "84290b5f1d34d6ecbc5f4e42cd9c285581468f26214e400bae4b6fe4f1afd02a" => :mojave
    sha256 "982caf1b34a78e5f5060c77dbbd08262a68b54fad42beaa579616eb35f7ffab6" => :high_sierra
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
