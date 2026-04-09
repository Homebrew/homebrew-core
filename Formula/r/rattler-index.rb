class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.27.22.tar.gz"
  sha256 "d3dc1b64dcd081abf68e0d900d91818fd5063b1ff392d2f62bd64680456381d2"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a6864c487e9069caba05015b48b544820e7befe8d0051f19dd538cd22961d5d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "907752908160a42f94ce0538d1c7b88d2bed444ca5cd4b6200bba70e5e57301f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c83dd7b80fb73c9a406199768afdc5c65088ce8e0cb9a6d0e3fd3c53c7eed6e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca252859c44478fe377dbcadd783a548980069140f1518a66e9aa11ce580bfd3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b8eac7271218fabcace3e564fd2e32569ef3b1e8392f8536a0084433cbee07f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9e03c35ef3913ef2ac1136bd478091fff8e95c4abd8efcebf7d5c5d9b876eaf"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    features = %w[native-tls rattler_config s3]
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/rattler_index", features:)
  end

  test do
    assert_equal "rattler-index #{version}", shell_output("#{bin}/rattler-index --version").strip

    system bin/"rattler-index", "fs", "."
    assert_path_exists testpath/"noarch/repodata.json"
  end
end
