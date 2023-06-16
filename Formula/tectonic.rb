class Tectonic < Formula
  desc "Modernized, complete, self-contained TeX/LaTeX engine"
  homepage "https://tectonic-typesetting.github.io/"
  url "https://github.com/tectonic-typesetting/tectonic/archive/tectonic@0.14.1.tar.gz"
  sha256 "3703a4fc768b3c7be6a4560857b17b2671f19023faee414aa7b6befd24ec9d25"
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
    sha256 cellar: :any,                 arm64_ventura:  "512157172f1e6b2b2390407018d204c9e8dd7139a612415c1ec753f0a3677868"
    sha256 cellar: :any,                 arm64_monterey: "ec100b87907a34ffc4045be5c3fb9e6af53e2926bd58bedf2046064b719d4724"
    sha256 cellar: :any,                 arm64_big_sur:  "83c3ed0760fe13444579c4c4ba1f08753c519f0443b3da2e1d50af4aa4c806e0"
    sha256 cellar: :any,                 ventura:        "bdc9b2c1561004ef56978f58bf5651fe9dd8991e3bd334af307edf1b67330db3"
    sha256 cellar: :any,                 monterey:       "ebf14ff54f3117ce322f74124c48289a423784beb85e9f2204ae313253a03cab"
    sha256 cellar: :any,                 big_sur:        "68de011c235082a15362b1a8ddaaf93476ff10f2928a441170474b598cc2751d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20e721bd3f724e9116a6915275822853cd2eb481407c0a17f18098be3ae2e8a5"
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
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version.to_s # needed for CLT-only builds
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
