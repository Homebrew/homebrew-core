class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.27.4.tar.gz"
  sha256 "d3f5a815c8648daf75f4e253bc71504db669ef27db34b18cabf5b39798a1352a"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "634c3674f45bc104469dac4e0b5dfa988dff38312465b925c0ed4a9637cb472b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8f6d2543050e73268e2e0a0629a790263bb43ee5cfcaaffc032a96f740da9cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef611c38dab0a36430934fa60478501666ca6005d2b7d8f0c3d6e1c67c51ed60"
    sha256 cellar: :any_skip_relocation, sonoma:        "edc136598664594c673341bf68f382bb421dfd45cf7a1f3345fd111143eb0253"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9cbcfb3ad578ce56672f35c3202afba39cfd485194c2eae90fbbff416d33fcb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a19feadb39e4a8fd73e84738d20694740847034928d3c119e2104ab76c8f788"
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
