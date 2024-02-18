class Tectonic < Formula
  desc "Modernized, complete, self-contained TeX/LaTeX engine"
  homepage "https://tectonic-typesetting.github.io/"
  url "https://github.com/tectonic-typesetting/tectonic/archive/refs/tags/tectonic@0.15.0.tar.gz"
  sha256 "3c13de312c4fe39ff905ad17e64a15a3a59d33ab65dacb0a8b9482c57e6bc6aa"
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
    sha256 cellar: :any,                 arm64_sonoma:   "5d439943a42a03ce37f19457878f9c75c971f8c2a63a60884b6dfb03f521c755"
    sha256 cellar: :any,                 arm64_ventura:  "07c10086836b60024a827af90ae69d67b7d975d7466485229f9f4edf1b0e2612"
    sha256 cellar: :any,                 arm64_monterey: "d9a65b32b52d0448375df01e46018b8431793999d4871cf9186ada1bfbbf32df"
    sha256 cellar: :any,                 sonoma:         "c4a7ec489e638a866fa6f8ec6136d47bd82c2715acfd92b507b8c300003f3c9e"
    sha256 cellar: :any,                 ventura:        "f69fb703fdc933829f87781eb52b598d82cd02a716912126ac73ba0a75419aa7"
    sha256 cellar: :any,                 monterey:       "42c6d1fc2d2b6eb75a3a89b571f0f7415b08824c615c474b51c9b598d802fb79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac62275657bbdb253f0d4acbeded7047c3b89b0c720d9e0633a9508ec9d4728e"
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
