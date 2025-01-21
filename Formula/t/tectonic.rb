class Tectonic < Formula
  desc "Modernized, complete, self-contained TeX/LaTeX engine"
  homepage "https://tectonic-typesetting.github.io/"
  license "MIT"
  revision 3
  head "https://github.com/tectonic-typesetting/tectonic.git", branch: "master"

  stable do
    url "https://github.com/tectonic-typesetting/tectonic/archive/refs/tags/tectonic@0.15.0.tar.gz"
    sha256 "3c13de312c4fe39ff905ad17e64a15a3a59d33ab65dacb0a8b9482c57e6bc6aa"

    # Backport `time` update to build on newer Rust
    patch do
      url "https://github.com/tectonic-typesetting/tectonic/commit/6b49ca8db40aaca29cb375ce75add3e575558375.patch?full_index=1"
      sha256 "86e5343d1ce3e725a7dab0227003dddd09dcdd5913eb9e5866612cb77962affb"
    end

    # Backport fix for icu4c 75
    patch do
      url "https://github.com/tectonic-typesetting/tectonic/commit/d260961426b01f7643ba0f35f493bdb671eeaf3f.patch?full_index=1"
      sha256 "7d2014a1208569a63fca044b8957e2d2256fa169ea2ebe562aed6f490eec17d1"
    end
  end

  # As of writing, only the tags starting with `tectonic@` are release versions.
  # NOTE: The `GithubLatest` strategy cannot be used here because the "latest"
  # release on GitHub sometimes points to a tag that isn't a release version.
  livecheck do
    url :stable
    regex(/^tectonic@v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ec1722650c30319f61d56d7d8cca8db7cc9e076ad4893606facfbd9ee69ae7b3"
    sha256 cellar: :any,                 arm64_sonoma:  "721748a97a49ff72d7104f4ac681a9bb4dc45b03918dc8ad381ad8222ed0fc66"
    sha256 cellar: :any,                 arm64_ventura: "60ddb06cede028376f301c6943862850df6a94dc51d019c2c0a7d8a34e1ad39f"
    sha256 cellar: :any,                 sonoma:        "94aae850c22adffae6daa088513cd87f5c33fc51413e3548fd781990d6743e6f"
    sha256 cellar: :any,                 ventura:       "a45fab4582fb61a2a8c09c4556c4c450c6a21bfda04fd3e8c0bd6e2a5ece07c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf78eafd736c3ef80d839669766e9c4ceb283772facbbe8aaa236084d6eda476"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "freetype"
  depends_on "graphite2"
  depends_on "harfbuzz"
  depends_on "icu4c@76"
  depends_on "libpng"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "fontconfig"
  end

  def install
    if OS.mac?
      ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version.to_s # needed for CLT-only builds
      ENV.delete("HOMEBREW_SDKROOT") if MacOS.version == :high_sierra
    end

    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

    system "cargo", "install", "--features", "external-harfbuzz", *std_cargo_args
    bin.install_symlink bin/"tectonic" => "nextonic"
  end

  test do
    (testpath/"test.tex").write 'Hello, World!\bye'
    system bin/"tectonic", "-o", testpath, "--format", "plain", testpath/"test.tex"
    assert_predicate testpath/"test.pdf", :exist?, "Failed to create test.pdf"
    assert_match "PDF document", shell_output("file test.pdf")

    system bin/"nextonic", "new", "."
    system bin/"nextonic", "build"
    assert_predicate testpath/"build/default/default.pdf", :exist?, "Failed to create default.pdf"
  end
end
