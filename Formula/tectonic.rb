class Tectonic < Formula
  desc "Modernized, complete, self-contained TeX/LaTeX engine"
  homepage "https://tectonic-typesetting.github.io/"
  url "https://github.com/tectonic-typesetting/tectonic/archive/tectonic@0.3.1.tar.gz"
  sha256 "3cef4305e5de4fc386fb4cff013502e330f235155696c425b0b20f828ccee57a"
  license "MIT"

  bottle do
    cellar :any
    sha256 "ed868dcee1ef9925b8368855814a19ccc6b6b78d8b98ba2492b94ff0f4881500" => :catalina
    sha256 "3dab6bcb9177fbe5b335f911b62d36f42bb11d0185febb2b19da0e82e1a5fc2c" => :mojave
    sha256 "966ce4ba6a7b1e907e3f0a9138b4e5c879d2ecd4fb866ab579b224c9ac310b4c" => :high_sierra
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
