class Tectonic < Formula
  desc "Modernized, complete, self-contained TeX/LaTeX engine"
  homepage "https://tectonic-typesetting.github.io/"
  url "https://github.com/tectonic-typesetting/tectonic/archive/v0.1.11.tar.gz"
  sha256 "e700dc691dfd092adfe098b716992136343ddfac5eaabb1e8cfae4e63f8454c7"
  revision 3

  bottle do
    cellar :any
    rebuild 1
    sha256 "db042190cb7aa26b8a926f36310968960fbd01ed34700df6e5a4ac00bd26fd32" => :mojave
    sha256 "1b35ff73005abc5627a4149d97b1259e7dcc222484bfc089fd8205d9efb9fb25" => :high_sierra
    sha256 "53068153d241239bc41f6b8a667bf03ee2e723621fdbadc2d35f62f250919011" => :sierra
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
