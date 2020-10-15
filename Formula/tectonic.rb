class Tectonic < Formula
  desc "Modernized, complete, self-contained TeX/LaTeX engine"
  homepage "https://tectonic-typesetting.github.io/"
  url "https://github.com/tectonic-typesetting/tectonic/archive/tectonic@0.1.17.tar.gz"
  sha256 "cbe2dcc2fd5c87a2e01643bb1d7cb8eb8bb4236832aaa39eedd7d334400d5adb"
  license "MIT"

  bottle do
    cellar :any
    sha256 "ede72897154ae1fac3d057d96c2a1efcc43dce09ee57ae73ed009549e349a253" => :catalina
    sha256 "42e7f93a00981e5f42de95487bf4f30913a6f8922984c5aa97525b55e07b2bb8" => :mojave
    sha256 "951d93798bab9b7dc50a267c6a0dafe504dd51ee5777f175350cbb141eb4e838" => :high_sierra
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
