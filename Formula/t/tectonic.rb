class Tectonic < Formula
  desc "Modernized, complete, self-contained TeX/LaTeX engine"
  homepage "https://tectonic-typesetting.github.io/"
  url "https://github.com/tectonic-typesetting/tectonic/archive/refs/tags/tectonic@0.17.0.tar.gz"
  sha256 "30adda98f67dd5389844f6023adeeb54b5475c17a54b777900644468fbc9765d"
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
    sha256 cellar: :any, arm64_tahoe:   "ee7d67061132d36e8cc70e643698a95228fc7c798d6717f349f523a78782ac8f"
    sha256 cellar: :any, arm64_sequoia: "6a82627d47f54e626c1db4bf1e0c217dc7cd8438c231f3bfd04ea19e50852466"
    sha256 cellar: :any, arm64_sonoma:  "02eca8f626b8063a4d386654e9d4147df8abeb8abb0a33afa48118cf88104284"
    sha256 cellar: :any, sonoma:        "b34a2b38838e4dcba6fb692d71ed8f4f87c6fe349425584a21377db1976cab7e"
    sha256 cellar: :any, arm64_linux:   "4ebbf66c75acbe74cd38b0cc9f0643c8bc4e1441b0979853b752d3353f315484"
    sha256 cellar: :any, x86_64_linux:  "b3b37f5506ed4d1bfbe9bd7662a2dfaf93a76a4b02c47033009b03b72e5da538"
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
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")

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
