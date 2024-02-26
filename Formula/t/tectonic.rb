class Tectonic < Formula
  desc "Modernized, complete, self-contained TeX/LaTeX engine"
  homepage "https://tectonic-typesetting.github.io/"
  url "https://github.com/tectonic-typesetting/tectonic/archive/refs/tags/tectonic@0.15.0.tar.gz"
  sha256 "3c13de312c4fe39ff905ad17e64a15a3a59d33ab65dacb0a8b9482c57e6bc6aa"
  license "MIT"
  revision 1
  head "https://github.com/tectonic-typesetting/tectonic.git", branch: "master"

  # As of writing, only the tags starting with `tectonic@` are release versions.
  # NOTE: The `GithubLatest` strategy cannot be used here because the "latest"
  # release on GitHub sometimes points to a tag that isn't a release version.
  livecheck do
    url :stable
    regex(/^tectonic@v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0f320deeee5ccf6dfbe44bcc8d420c450d3dda8f8d23932a15a3f81632f893fc"
    sha256 cellar: :any,                 arm64_ventura:  "c187f88bdaa10a481b76c085f87199cf17b3e4cc698f90925da83e94541ef071"
    sha256 cellar: :any,                 arm64_monterey: "cd967ec9dd43d75b2ba9cc2b80356390bd92a0c10fbc03695f5fe4e1b48ae028"
    sha256 cellar: :any,                 sonoma:         "120fa9462f3704dbcda0611809a8a4c9b76a3b452c5c56e2e19bf05585b08249"
    sha256 cellar: :any,                 ventura:        "589e7fb463bb57a314590c1849a97f3c075ecad961c1db4860b75b4bafd39a82"
    sha256 cellar: :any,                 monterey:       "52548a8b0607009b762d4b2cb97b449a045c4c8bf02a761dbbd17335dd6cadb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5327e3c4ba4378f14adab5052d98464770296d2010bb432b94bde995d297b069"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "freetype"
  depends_on "graphite2"
  depends_on "harfbuzz"
  depends_on "icu4c"
  depends_on "libpng"
  depends_on "openssl@3"

  def install
    ENV.cxx11

    if OS.mac?
      ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version.to_s # needed for CLT-only builds
      ENV.delete("HOMEBREW_SDKROOT") if MacOS.version == :high_sierra
    end

    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

    system "cargo", "install", "--features", "external-harfbuzz", *std_cargo_args
  end

  test do
    (testpath/"test.tex").write 'Hello, World!\bye'
    system bin/"tectonic", "-o", testpath, "--format", "plain", testpath/"test.tex"
    assert_predicate testpath/"test.pdf", :exist?, "Failed to create test.pdf"
    assert_match "PDF document", shell_output("file test.pdf")
  end
end
