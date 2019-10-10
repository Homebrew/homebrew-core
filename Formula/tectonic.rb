class Tectonic < Formula
  desc "Modernized, complete, self-contained TeX/LaTeX engine"
  homepage "https://tectonic-typesetting.github.io/"
  url "https://github.com/tectonic-typesetting/tectonic/archive/v0.1.11.tar.gz"
  sha256 "e700dc691dfd092adfe098b716992136343ddfac5eaabb1e8cfae4e63f8454c7"
  revision 3

  bottle do
    cellar :any
    sha256 "b377715e0bda43737904c03699969655d4973c19b49f4dc7ba3cdee3f2790b7c" => :catalina
    sha256 "9902c83484f4b8aa3b3fca5bc72cee473bbf0b9928ea8f3267943c18f15801f7" => :mojave
    sha256 "003ba188e0a2b531726552ef85b9ace546fe0d7ce99a7f369f5377a97bb37186" => :high_sierra
    sha256 "f6bee609fb6dc3433a5e9c28fec1fc575f6d9703e8c031fa439e5e9e1cb7f42a" => :sierra
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

    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix

    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    (testpath/"test.tex").write 'Hello, World!\bye'
    system bin/"tectonic", "-o", testpath, "--format", "plain", testpath/"test.tex"
    assert_predicate testpath/"test.pdf", :exist?, "Failed to create test.pdf"
    assert_match "PDF document", shell_output("file test.pdf")
  end
end
