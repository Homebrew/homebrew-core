class Tectonic < Formula
  desc "Modernized, complete, self-contained TeX/LaTeX engine"
  homepage "https://tectonic-typesetting.github.io/"
  url "https://github.com/tectonic-typesetting/tectonic/archive/tectonic@0.12.0.tar.gz"
  sha256 "96a53ab5ba29d2bf263f19b6f07450471118bf2067c610b362a1492d0b9b989f"
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
    sha256 cellar: :any,                 arm64_ventura:  "decb0609b7fcb74eb2a31ae866ffa6c5a029fb952f0e7b6340ec2a62389d3082"
    sha256 cellar: :any,                 arm64_monterey: "95d88b3e9f86985ef1ebf8f8312c54e74d990ca27ca067e5da680b5d4018b838"
    sha256 cellar: :any,                 arm64_big_sur:  "c334df1e51fe1d910f9a2918f97f0a0307254de9cc0005cdb03b9c92640b42bf"
    sha256 cellar: :any,                 ventura:        "8169a82836c8b7e569f152b9ff7eb1780b3c49eeaa55f9ae2c650e7c23f6d60a"
    sha256 cellar: :any,                 monterey:       "427b5701bb6a6548d97ee8bf8b2bac83d99e901bd661e8140bb84d4e465f6b6e"
    sha256 cellar: :any,                 big_sur:        "19c2550f5990ca570c579fc31b9329e17975de795ada0839eb9ddada3d30de85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3cecf70dfe2804bc491cb7954d09bfd5c6948ccc8cb0249ca2ae5d96795d3eb"
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
