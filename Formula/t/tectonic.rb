class Tectonic < Formula
  desc "Modernized, complete, self-contained TeX/LaTeX engine"
  homepage "https://tectonic-typesetting.github.io/"
  license "MIT"
  revision 2
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
    sha256 cellar: :any,                 arm64_sequoia: "241db42c1447078e8e0482edcc66a29913ca412bf69de14ba04392df4a9200f0"
    sha256 cellar: :any,                 arm64_sonoma:  "e3c07400585937c7a0e7391d4ed6b038a4839552a6cbcf838b9ab521de9decfd"
    sha256 cellar: :any,                 arm64_ventura: "eb6d3c4e2539a5c35c6cdfba38731d9512a098cf9f5161a2ce71560298752be6"
    sha256 cellar: :any,                 sonoma:        "c384757312754a13da913bacaaf00bc6fda14ecbb8b2b11380ba69e380c9eb01"
    sha256 cellar: :any,                 ventura:       "c021e77bb90017445aa1e7f6ad2497211112596d0d9de3e193ec9a9256b7c519"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6bcf34b8ef21be00079a5790a763db9e10d6c95bbc3193f51a10a735f7b54f2"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "freetype"
  depends_on "graphite2"
  depends_on "harfbuzz"
  depends_on "icu4c@75"
  depends_on "libpng"
  depends_on "openssl@3"

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
