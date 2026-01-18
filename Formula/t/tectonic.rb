class Tectonic < Formula
  desc "Modernized, complete, self-contained TeX/LaTeX engine"
  homepage "https://tectonic-typesetting.github.io/"
  license "MIT"
  revision 5
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
    sha256 cellar: :any,                 arm64_tahoe:   "f56823a0baaed02168099c191567bb2deaf5714813e731d3c7182abc45571f96"
    sha256 cellar: :any,                 arm64_sequoia: "054a9f7723f8b229fd2a46aa8ec42187f877108295e0194511cf1ba9b997c227"
    sha256 cellar: :any,                 arm64_sonoma:  "46fb7cf69dd8e1527ae95e110671badf51503715d372a8d51f14fdd8fe118891"
    sha256 cellar: :any,                 sonoma:        "3dcd2b5d5cc04cf574b86e96e0f2109f306ee73a41d32a2c307b1aeb75d00801"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3be3c6d8390901d6e7824be28657e88bd0d496d593f83413f12f6a6ede6353ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82aa476e71429b2346538251f37986741000f91e48142e312ba8cd103c4736b1"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "freetype"
  depends_on "graphite2"
  depends_on "harfbuzz"
  depends_on "icu4c@78"
  depends_on "libpng"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "fontconfig"
  end

  def install
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version.to_s if OS.mac? # needed for CLT-only builds

    # Fix to error: implicit autoref creates a reference to the dereference of a raw pointer
    # for rust 1.89+, remove with next release
    inreplace "crates/engine_bibtex/src/xbuf.rs", "(*old).len()", "(&(*old)).len()" if build.stable?

    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

    system "cargo", "install", "--features", "external-harfbuzz", *std_cargo_args
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
