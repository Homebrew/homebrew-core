class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.22.5.tar.gz"
  sha256 "9cef3f2122c18c7c6c06417c087d7cc7153d2ceca0d0d8bb2fa9892d1299c016"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9467ec31c96b21611863561aea2248de22d62f9378950a395964cc8fdc541d45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e2e70216465707e17884d5b279b525d58bab164a7150c2141a9c4eb122f9643"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6a7b398ac3534454738bb4478cf1afe989f91cffc5a060b9571abab44ae34af1"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6a59134fae2d3b82d38e654d3ad4d345d7bbf7942425066004e35e6428cc064"
    sha256 cellar: :any_skip_relocation, ventura:       "b1379507b76570d785d01ec4644952998e7c6672e0cb4d20f56cad2eb2dd01f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c5063c43f767fc11d84835cc0b3d8d2f9eeec0cc2f076be260f134b0c59327c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c62236ae9754ca57cc83df6aa73d87f94848f34e3e273825fea9a22eb2576800"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", "--features", "native-tls", "--no-default-features",
        *std_cargo_args(path: "crates/rattler_index")
  end

  test do
    assert_equal "rattler-index #{version}", shell_output("#{bin}/rattler-index --version").strip

    system bin/"rattler-index", "fs", "."
    assert_path_exists testpath/"noarch/repodata.json"
  end
end
