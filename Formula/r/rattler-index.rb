class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.34.5.tar.gz"
  sha256 "162b37e24e7e73b5db8ba88a9372a6c5bd779404410c7d2759866a6f88f81fe6"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f3a8b08bf3d300e74a3f795b8d011bbe04624de83071f2715b5f62774c5b0548"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "773e28a6d883597809b3f8838ec3bdad67fb6782672012e8a3d6fd67a8e60742"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2ab39c21acecea486f0a259ac8bd4465b9071c33a1d89f5cac83c9b921d1917d"
    sha256 cellar: :any,                 arm64_linux:       "d036a8b0922f08bce53b05a69bca2ca9befb2a7f64e422bc75cfd6d0a9d02efd"
    sha256 cellar: :any,                 x86_64_linux:      "a5a109197b209471d045542025aefbf433fa61078bd7fb1e1c13ba06d17703ae"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4") if OS.linux?
    features = %w[native-tls s3]
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/rattler_index", features:)
  end

  test do
    assert_equal "rattler-index #{version}", shell_output("#{bin}/rattler-index --version").strip

    system bin/"rattler-index", "fs", "."
    assert_path_exists testpath/"noarch/repodata.json"
  end
end
