class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.21.2.tar.gz"
  sha256 "df1403bdbac1e2e1e8066fbf6d2affc5a0a26d78b94f1424d1a8f4fc37828315"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fdca78b53eeb28a2fe2b416d6e4d77106fc1fe82193c4e6d8292684d4a588470"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6475e76c6d7c2bc760372f1e838c8f60acd03aef256d98cab27ad9cee8de0e17"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d620c48052db42b6cb87b7b0ea64faf2e830896aaff56a72050490bd5bc8e49c"
    sha256 cellar: :any_skip_relocation, sonoma:        "650996fcac5e8876fa1abc4cfbe6a9a4588f3229de0056d3a5e1fadf579aaf19"
    sha256 cellar: :any_skip_relocation, ventura:       "a9a155273dd9237fde89414ba6fa46453b2ef78092624560d88a8bd4e4d494de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "927b18a21f7cfe260edd44e040a1f692d856011601e3b62eaaaf2d16c5507586"
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
