class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.31.6.tar.gz"
  sha256 "91c15976b0e874428437c42e0cafef0159604922a4d2dae1e42c6670ea21af1e"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e7016715c588fdbfca0479ce726fd4e0cfecffb16383353d92e94fa7f809378b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3c04e39fccab52d11cbf466ee10388a6391691ec91614d3f29a2c7f25eaf30c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "54c119bb63d144b121c949933074d28cfcf7ccc0b968870f2a6dfa202b738c54"
    sha256 cellar: :any,                 arm64_linux:       "b88ae3b9ab1340fffe89f595d25baf28f7fb866be05234b49af3a5bdcfb7df62"
    sha256 cellar: :any,                 x86_64_linux:      "7a0560844f28ee5ba09fad897556bc98926933e3e09b25e7ca4fcefdebad8a0e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
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
