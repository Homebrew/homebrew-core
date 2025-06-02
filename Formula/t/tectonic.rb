class Tectonic < Formula
  desc "Modernized, complete, self-contained TeX/LaTeX engine"
  homepage "https://tectonic-typesetting.github.io/"
  license "MIT"
  revision 4
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
    sha256 cellar: :any,                 arm64_sequoia: "ffc8602e1b2f1a67000d75005c1cbaae38bdd947e553c9f0b2691b808c37b485"
    sha256 cellar: :any,                 arm64_sonoma:  "d285d2e6edecf5aa4eff882adfc33da8b77f42e5c38e830f71f4df3bfeaa51f2"
    sha256 cellar: :any,                 arm64_ventura: "f32891c5831052e3bb42bc8fb0e16b03bd9c4d7589c352f5aaf44d75f025b23c"
    sha256 cellar: :any,                 sonoma:        "fa701da13aceb845275ab33d2be416e8e920de049200aa24f3b59f0ece64e7df"
    sha256 cellar: :any,                 ventura:       "56ce8b708073b61d53ad803ac2b7977023b3361db901051e314387d15f1ed766"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9503c0b5a4f9746927ca7d4773284b0880289a9197d4512034bd0b7516d313b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "729380f2cf1ff68094a032dc5c4dc21fcbfc70dba58bbf2c597b1b2d675fcbc3"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "freetype"
  depends_on "graphite2"
  depends_on "harfbuzz"
  depends_on "icu4c@77"
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
    assert_path_exists testpath/"test.pdf", "Failed to create test.pdf"
    assert_match "PDF document", shell_output("file test.pdf")

    system bin/"nextonic", "new", "."
    system bin/"nextonic", "build"
    assert_path_exists testpath/"build/default/default.pdf", "Failed to create default.pdf"
  end
end
