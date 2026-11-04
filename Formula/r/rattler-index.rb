class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.34.6.tar.gz"
  sha256 "69b4092553633089f2d97d71f57d86773100a401642361236a6acafb420d19da"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "42a4b58a4623bc1200d328346ec2b2a9aec79d70753c5f9e2551c30851818127"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d9457462c4541b26d6edc6251409021fc6654d21989db10bbf3e25be1ca82038"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "139d80aed109a4efd4c4e4860cd5e7d90d22975f37c7ae0db6a7af3d7ecfa958"
    sha256 cellar: :any,                 arm64_linux:       "c31869e029cc08256ae7b8f1e0a9b7b4e84aed50528bdd3745d450d80012cbfb"
    sha256 cellar: :any,                 x86_64_linux:      "253e6ea804828ce47d39fe4e15cb6a5d4c587cb05c5611c09f83f3a515ef01bd"
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
