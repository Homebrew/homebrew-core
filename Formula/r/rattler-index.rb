class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.25.2.tar.gz"
  sha256 "fecc2f2af079aa73c4ef70d5c7028e29f565156843f4d1e3e96596ad7829a398"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37f22b30799ba958d272b252b66226e4e4c2861084211420a4a45913a0b82b96"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca6fb76d0685ce173c0f595a416248f5f8da40c619013154e634fac054628fa3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd4044f84ad6732ae3360bf8699fee637514992d0d8f284f193c9b5446f31f8f"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad39e4fc3c19e4c5fcb2c3c0e89519d2a58f776837fcaeb5b71ebdb262264f85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bdeb6df862ad490b6f1a35c04a03d02cb922f6b7304a55985c923fffc60f2d59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "086dd0ddcdaa09983f09d22c07bf9cbfde0af28a4e83e06e4b259ec52b4aa208"
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
