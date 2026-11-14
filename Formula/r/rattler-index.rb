class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.34.8.tar.gz"
  sha256 "e74bbb4a7ba009b076c48757d64a00a3c9e894047cdde6681e8b30da44fa4a25"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b76ae45e73d54842eab86156cbf6d8ef136917af0465215afecb67ef5a4d628e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3d939eda8cfa456b0ea30ad4165c97b5bcdf7acd32a9bdcc9ab43d4f77b736d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d753b21de8190b98b7793fd4fb672eae7fb6cc8cafba17cc8d6ba973d6c751f5"
    sha256 cellar: :any,                 arm64_linux:       "f8a9d874a4f8adf3b57a9c6d1dcf1f8a155335d868a06d077db1456ab53064c9"
    sha256 cellar: :any,                 x86_64_linux:      "8c6695da53208da07149a85f06c135e01bf0fe58cb881d0859c6a1ec25b692a1"
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
