class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.27.13.tar.gz"
  sha256 "0f464a58f753edb7e3069aa442da0a89b51be5d5c3d74d965a4721204c02d4d2"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e586e54458bb561382a566b0c5fa4a0d40a7d79779ed661b1dfb3a711a4ad6c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c79530bc4efddfceeaa129d2faffe1e2f161d8816151f43d245c3d6b8a94b8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "522e9935bc463718cdb37db5f6b20b9ec2662bbc6242a6b4f3894c8284a318c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "177921352e7c4274ebb568b38cf7e76d72b9a9be03579787a7a89513ab7c45f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13bef8c95b605123d0b1e3f0a480757100c9283d0cc587c01aeed28b71817e1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "697b133ac5527305c75c0cae83f74834954033cf4d55789acd16d9ae9e2049c9"
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
