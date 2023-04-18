class Tectonic < Formula
  desc "Modernized, complete, self-contained TeX/LaTeX engine"
  homepage "https://tectonic-typesetting.github.io/"
  url "https://github.com/tectonic-typesetting/tectonic/archive/tectonic@0.14.0.tar.gz"
  sha256 "2191e3599b7e34f01d24a8d0ed873d8a8696e5ed4af05e9ce30685a053e9b57a"
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
    sha256 cellar: :any,                 arm64_ventura:  "41de7e1d0349f5f1bc159c152b5b6389c7ff5fdb3fe2c12598d25a02313efc76"
    sha256 cellar: :any,                 arm64_monterey: "55a66a6125f49899cdb2c26ecde5d9356708cfe600d81ff408a2b95a788124b1"
    sha256 cellar: :any,                 arm64_big_sur:  "62c801d5b70ab19fe54d6590a322d107951f46fd37bfc559534548b0477d74c3"
    sha256 cellar: :any,                 ventura:        "4099e597f8ec466736f262c3101393df9c7cc6137d6be6becd3439dc47ee55fb"
    sha256 cellar: :any,                 monterey:       "2dc357aa3efd9b560fc22945513b3ce31fb0d40b87f76c19ce984c569fc4df42"
    sha256 cellar: :any,                 big_sur:        "e4cb4139024e5c648ab798d5c1b0f5c2d08a535969f1cc46cca8a936d6f0ee00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "caf8f73a657cec4af6d727f4bc2e2d8c467b4a0c178c69367a6246168015f691"
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
