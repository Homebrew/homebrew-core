class Tectonic < Formula
  desc "Modernized, complete, self-contained TeX/LaTeX engine"
  homepage "https://tectonic-typesetting.github.io/"
  url "https://github.com/tectonic-typesetting/tectonic/archive/v0.1.11.tar.gz"
  sha256 "e700dc691dfd092adfe098b716992136343ddfac5eaabb1e8cfae4e63f8454c7"
  revision 1

  bottle do
    sha256 "1a7529e618b09f3b3c7852d7734f631847c7d31334ebe43d10a5da3dc14bc6b4" => :mojave
    sha256 "5bfc6c5d8d8f1c80ed55e7543bb081a6fa1f83faa8ca01759541b179f62c9c65" => :high_sierra
    sha256 "86202b51be7fe24c4306ca5e38aa39112bc879d0f651bffdee0d35e1ca71d72f" => :sierra
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
    pkgshare.install "tests"
  end

  test do
    system bin/"tectonic", "-o", testpath, pkgshare/"tests/xenia/paper.tex"
    assert_predicate testpath/"paper.pdf", :exist?, "Failed to create paper.pdf"
    assert_match "PDF document", shell_output("file paper.pdf")
  end
end
