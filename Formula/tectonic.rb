class Tectonic < Formula
  desc "Modernized, complete, self-contained TeX/LaTeX engine"
  homepage "https://tectonic-typesetting.github.io/"
  url "https://github.com/tectonic-typesetting/tectonic/archive/tectonic@0.10.0.tar.gz"
  sha256 "8c3295007b2602ff1a43a42d335589ebfe3731072e749a8087348ad0cfecf662"
  license "MIT"
  head "https://github.com/tectonic-typesetting/tectonic.git", branch: "master"

  # As of writing, only the tags starting with `tectonic@` are release versions.
  # NOTE: The `GithubLatest` strategy cannot be used here because the "latest"
  # release on GitHub sometimes points to a tag that isn't a release version.
  livecheck do
    url :stable
    regex(/^tectonic@v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "de5f526a6d32b73ebbdda16c84944b20047dc9d478566237bedd7cd95ccb5eb3"
    sha256 cellar: :any,                 arm64_big_sur:  "50263a63aedf5aea33820b3fc3e8814a3ac195544d8ffcf5fc037ea2192466e0"
    sha256 cellar: :any,                 monterey:       "b4d72b0a71de6205ad39a21152adf95f59b8a0f4247b2bbb7dfd93b0d2d8eae1"
    sha256 cellar: :any,                 big_sur:        "2b127985d09155fbf8cb240ac2911051e5a55d4563402e0d85a7b4678fdc6919"
    sha256 cellar: :any,                 catalina:       "bc665928a9e966fc5533c3d84d39b10b2d4fd104ed0db910d747db9e3263fd22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ff082c93602fc55b52baa63215733279e418ff37234d70042365bebf79a065e"
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

    system "cargo", "install", "--features", "external-harfbuzz", *std_cargo_args
  end

  test do
    (testpath/"test.tex").write 'Hello, World!\bye'
    system bin/"tectonic", "-o", testpath, "--format", "plain", testpath/"test.tex"
    assert_predicate testpath/"test.pdf", :exist?, "Failed to create test.pdf"
    assert_match "PDF document", shell_output("file test.pdf")
  end
end
