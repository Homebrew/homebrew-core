class Tectonic < Formula
  desc "Modernized, complete, self-contained TeX/LaTeX engine"
  homepage "https://tectonic-typesetting.github.io/"
  url "https://github.com/tectonic-typesetting/tectonic/archive/tectonic@0.3.1.tar.gz"
  sha256 "3cef4305e5de4fc386fb4cff013502e330f235155696c425b0b20f828ccee57a"
  license "MIT"
  revision 1

  bottle do
    cellar :any
    sha256 "a24dea34eeffb739742ed83730fad8b30e55c92b2a601d145e589ecf118fc68e" => :catalina
    sha256 "3e6a1e4947822ad29446dc26234aa5c2158e05975a2ddccb80314a5ec78eeadc" => :mojave
    sha256 "4c8ba781aab4daf20287f059bb3b5668339b1596e007e6d0d0e1a94bebd35b5a" => :high_sierra
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
