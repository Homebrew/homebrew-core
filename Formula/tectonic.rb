class Tectonic < Formula
  desc "Modernized, complete, self-contained TeX/LaTeX engine"
  homepage "https://tectonic-typesetting.github.io/"
  url "https://github.com/tectonic-typesetting/tectonic/archive/tectonic@0.1.16.tar.gz"
  sha256 "341563df89d1715001419b81ce394ea36daf190171d654dcf70214fd12b2d02a"
  license "MIT"

  bottle do
    cellar :any
    sha256 "78fc34b9a5a3b20ae0a6d4110ac1f811e1f17fae0ae560e47c71b91d58bbf2de" => :catalina
    sha256 "bc7c84dff396e23cb49d4e9a03ccb1d96f8e9426d225986d94d1601641d099f2" => :mojave
    sha256 "6d66281d3ceb23221b864c3eaaf1bd3717d188e01ff6a4cd382a7bc58a4d4c49" => :high_sierra
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
