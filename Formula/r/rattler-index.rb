class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.33.5.tar.gz"
  sha256 "3834093a21435ab17480861b8b4518e5f3320bf8c95a9b3cf0c360289571d26c"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e25a60ca7293b5934f3c9d84a0815da2dc6732e84306834a154026cba53e2d9e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fae177dfcef32fd65247340c9ed32dd403fc2df522ab401d046ea34950b5bb20"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "73fbc59ebd31eb3f651a198d4522a07dfb11d66ccd9c2ecf01c22c86bcbf52de"
    sha256 cellar: :any,                 arm64_linux:       "03d71ca58ddb44667dfc58120a47114e010cf8933e246355d13bebb81dfb32fd"
    sha256 cellar: :any,                 x86_64_linux:      "e2e220435b2b88bc9c699f5649f26caed4361646cd4c4b1084d2c094b9df6fdd"
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
