class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.27.3.tar.gz"
  sha256 "6b57dbc5138e6323e9ebb145a79c755fd2b9411e7b4484dda64259a21a14f0eb"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3779315e9f0f2947e491bb5459e8229cc69fd9e88e4fb688dcf7fc18517c7acd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e990f65c835eae968ef04253dfb2e8706fc687982e3b254bd3a02162ec11d28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "386112c82f2838d564b7bd450a3112f67094b12af167f5200fcb2d31c32a9706"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d748c4d9897862228a920680e28a269d9cfffdf7052da5a7be527829b4e9ed9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7a7b512ead0f6c7aafd99f27cc32a88954ca47e57723f5ee6c6cf271ae7d0bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2122b933f22437e6f84cc7aeeda8ae5f97c37189a67b602e0b5441f1c0ecebbf"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", "--features", "native-tls,rattler_config", "--no-default-features",
        *std_cargo_args(path: "crates/rattler_index")
  end

  test do
    assert_equal "rattler-index #{version}", shell_output("#{bin}/rattler-index --version").strip

    system bin/"rattler-index", "fs", "."
    assert_path_exists testpath/"noarch/repodata.json"
  end
end
