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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "145a7685f5de0d93a3c60cf68e83ea82d7d17ae8ede4dcb24413cb50a6c6c258"
    sha256 cellar: :any,                 arm64_sequoia: "2262f768187009453cd9effc4e2a119d3a71a980b3089ebfc8f10b8da1258bc0"
    sha256 cellar: :any,                 arm64_sonoma:  "03df9945f9ddd870a2ce353c2e1139f07f7a4815f6f83f2bea10b40739ccddb4"
    sha256 cellar: :any,                 sonoma:        "af3203894e6285a96ff995fe00649b80305505c66ab6c6a77b7e1676b60c0112"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b4325f7f957ab41aa7fec285eae1ff5c5d74563098062343b8b5bea4b336044"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9e31afdd7aa5513cc754db0abb6fd66f75acb63866301fd6ee46b86dfc12a10"
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
