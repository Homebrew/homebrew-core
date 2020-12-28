class Tectonic < Formula
  desc "Modernized, complete, self-contained TeX/LaTeX engine"
  homepage "https://tectonic-typesetting.github.io/"
  url "https://github.com/tectonic-typesetting/tectonic/archive/tectonic@0.4.0.tar.gz"
  sha256 "de465545f20c12007c54a77e94144611b4d1d3e4837cbdfaf30a3c161c89ca21"
  license "MIT"

  bottle do
    cellar :any
    sha256 "374962deea5595efb5b0e7b36821a9c97727e1e6035063edd1b59dd519ae61a0" => :big_sur
    sha256 "8ad19de49dba54279cd0739ff369bf980490c0fc7538dfe137d2b1b3492fe775" => :arm64_big_sur
    sha256 "b0aab588b2ad733f37aa380bd8b6ef1985ffb1f41a345ad6829193a7eba6381e" => :catalina
    sha256 "566f6be7025d4f228f66c26f45eb1342cedfadbe33d9979aa72da89e2c5e4ee7" => :mojave
    sha256 "d5c2e447def3051174e6a9f1578d7df132b10ab95db3e86c41a49bb1fe8d5761" => :high_sierra
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
