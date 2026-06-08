class Tectonic < Formula
  desc "Modernized, complete, self-contained TeX/LaTeX engine"
  homepage "https://tectonic-typesetting.github.io/"
  url "https://github.com/tectonic-typesetting/tectonic/archive/refs/tags/tectonic@0.16.9.tar.gz"
  sha256 "9861d4d4230b987d8560f1b84fe6c8a550738401be65b9425b0c7d0466178f2b"
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
    sha256 cellar: :any,                 arm64_tahoe:   "4bf0bc26d2c17b8f634de7950a210a8bbd5cc2f7567c4adfa20649b6731c90cb"
    sha256 cellar: :any,                 arm64_sequoia: "4fe59b794a9b21039edfd84a23c9dee722cec9647d8b823f518d12731a456e8a"
    sha256 cellar: :any,                 arm64_sonoma:  "1ced7eecb83209b942b27221528cce685254a3f94fc45c0d7611f816c8b8262c"
    sha256 cellar: :any,                 sonoma:        "f59976400ce7c94f3b40a14dc1cc152f148848a53bad00301bc0f1d5b9a3007a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d3a08fa8228b9c146a9ea5145835f6231a18bd71f6b528593738649a7f7826dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e76fde85d4a89ad25e04159555dad0c1afa3112a97df58148edd8383adbba09a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "freetype"
  depends_on "graphite2"
  depends_on "harfbuzz"
  depends_on "icu4c@78"
  depends_on "libpng"
  depends_on "openssl@3"

  on_linux do
    depends_on "fontconfig"
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version.to_s if OS.mac? # needed for CLT-only builds

    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

    system "cargo", "install", *std_cargo_args(features: "external-harfbuzz")
    bin.install_symlink bin/"tectonic" => "nextonic"
  end

  test do
    (testpath/"test.tex").write 'Hello, World!\bye'
    system bin/"tectonic", "-o", testpath, "--format", "plain", testpath/"test.tex"
    assert_path_exists testpath/"test.pdf", "Failed to create test.pdf"
    assert_match "PDF document", shell_output("file test.pdf")

    system bin/"nextonic", "new", "."
    system bin/"nextonic", "build"
    assert_path_exists testpath/"build/default/default.pdf", "Failed to create default.pdf"
  end
end
