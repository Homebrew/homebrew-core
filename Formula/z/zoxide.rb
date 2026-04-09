class Zoxide < Formula
  desc "Shell extension to navigate your filesystem faster"
  homepage "https://github.com/ajeetdsouza/zoxide"
  url "https://github.com/ajeetdsouza/zoxide/archive/refs/tags/v0.9.9.tar.gz"
  sha256 "eddc76e94db58567503a3893ecac77c572f427f3a4eabdfc762f6773abf12c63"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a82505577d2966650cc8627de4017a136a93b47878292bd655f0e88599220f66"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d65d45c8afa409ab16b6ebb5408f5ad351467cb61dfc34b10489f4763bc856dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c86d40f6688a7c7d1716b474d97b09900709ef842215106e4458d8c495a62df"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f35975692aa8c38f9ae6b3868122ed8710cb35b3c470844b32cf246cbd80944"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa8fb13ba0cd9a26df2de6472b1d6eb944eee0fcde663b0cffd69dc171a9c2ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7aa96060fdfce45c0347eccb89f3d9b5cdaf97d43fc71c0f376867d8a26d942e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    bash_completion.install "contrib/completions/zoxide.bash" => "zoxide"
    zsh_completion.install "contrib/completions/_zoxide"
    fish_completion.install "contrib/completions/zoxide.fish"
    share.install "man"
  end

  test do
    assert_empty shell_output("#{bin}/zoxide add /").strip
    assert_equal "/", shell_output("#{bin}/zoxide query").strip
  end
end
