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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7135dc0d2d2093931cd12d80a95740c54fd0d8650edc56570c6df9786102728f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fc0b40f1449d907de768c64f1e751d8b6000b1dbec937db9f5470d939942a763"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "df621fee6f003baba53ae510bbde9812ff51ee58277f4c563b348488c7ecdee0"
    sha256 cellar: :any,                 arm64_linux:       "4d661d1d3f599ab6f176fe0f8d163fd789410309e6a9f3edc2d594660c61157b"
    sha256 cellar: :any,                 x86_64_linux:      "7c4b8dde97628816ed5f4fff723b265a0b873dbfef8313d17c0b4095fc584acd"
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
