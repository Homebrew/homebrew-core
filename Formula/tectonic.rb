class Tectonic < Formula
  desc "Modernized, complete, self-contained TeX/LaTeX engine"
  homepage "https://tectonic-typesetting.github.io/"
  url "https://github.com/tectonic-typesetting/tectonic/archive/v0.1.12.tar.gz"
  sha256 "30d2e0fe31145a10097368f11a00540ba201be43d28e7ad580699f47bfa70bf4"
  license "MIT"
  revision 2

  bottle do
    cellar :any
    sha256 "bd48e4e17779696ca1e647b1809ffbe65821e6387e1c787acf0ab1168bd6c059" => :catalina
    sha256 "b01e0fad7b78afa074addd3e4e423211a4c66b327a6365639fb1f70b20af2f1e" => :mojave
    sha256 "1a9f68211f8f9e8268652eb367d1cbafcab3bfcd5779a0be9d71ef456b326de9" => :high_sierra
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
