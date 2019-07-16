class Tectonic < Formula
  desc "Modernized, complete, self-contained TeX/LaTeX engine"
  homepage "https://tectonic-typesetting.github.io/"
  url "https://github.com/tectonic-typesetting/tectonic/archive/v0.1.11.tar.gz"
  sha256 "e700dc691dfd092adfe098b716992136343ddfac5eaabb1e8cfae4e63f8454c7"
  revision 2

  bottle do
    cellar :any
    sha256 "a862b7c4cbe355b1c3c86aa6601e757e50f51f4e205b29edece526428b09ebcd" => :mojave
    sha256 "8820a091d0bfcd31ad2bc5b8c8d9f0a29160a47497d00f03bc332e8c0bfe509c" => :high_sierra
    sha256 "76005a41861cee9fd834d46d84f33c2f8a09f887770e29e569d64b1bb8110d49" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "freetype"
  depends_on "graphite2"
  depends_on "harfbuzz"
  depends_on "icu4c"
  depends_on "libpng"
  depends_on "openssl"

  def install
    ENV.cxx11
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version # needed for CLT-only builds

    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl"].opt_prefix

    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    (testpath/"test.tex").write 'Hello, World!\bye'
    system bin/"tectonic", "-o", testpath, "--format", "plain", testpath/"test.tex"
    assert_predicate testpath/"test.pdf", :exist?, "Failed to create test.pdf"
    assert_match "PDF document", shell_output("file test.pdf")
  end
end
