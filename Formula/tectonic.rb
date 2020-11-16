class Tectonic < Formula
  desc "Modernized, complete, self-contained TeX/LaTeX engine"
  homepage "https://tectonic-typesetting.github.io/"
  url "https://github.com/tectonic-typesetting/tectonic/archive/tectonic@0.3.3.tar.gz"
  sha256 "c0aa60186f2e7f37af67dafbdccfc7a99ca5ce084651d8fcabe7561b941dcb97"
  license "MIT"

  bottle do
    cellar :any
    sha256 "b55c1793a8f868375c21137f4535e5202843b280c3b32a49adb36e55af2c7f06" => :big_sur
    sha256 "e6dc59416b2d8734e41e30701f96f5f99497d07914461d2f4e38d4d1801dc95c" => :catalina
    sha256 "40c42d14b239433646c5c87ae7308a08c82689cfe21ee53f924c476b70782163" => :mojave
    sha256 "13753e2b4468ae499d380654334e3a5dd1afece57491625d654e300f9d7876c4" => :high_sierra
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
