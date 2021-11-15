class Zoxide < Formula
  desc "Shell extension to navigate your filesystem faster"
  homepage "https://github.com/ajeetdsouza/zoxide"
  url "https://github.com/ajeetdsouza/zoxide/archive/v0.7.9.tar.gz"
  sha256 "aea1a55d107a2367d46be19617fbd8fb440d906121a84d6d9e7b86f3a24fbad4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b120b1e84f236e8b7214d4362ce5ea35de0236448af122e565aff03556da9447"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7154297736107b957a8e4e2bf56336833d0997389da5ea6b59bfd90add51e91a"
    sha256 cellar: :any_skip_relocation, monterey:       "b4498343517aeac760fdfb01839425fb8cf66ae595d1a65b615e569dedaeee14"
    sha256 cellar: :any_skip_relocation, big_sur:        "664fbe640ad0301f452f17aa16533c9ffeb8154209c5741b56c4b21c9a5f3828"
    sha256 cellar: :any_skip_relocation, catalina:       "6d161a406e087ae16efc384c21d709ffe202e3fe0cf92e31367a36d0d6f38243"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17d9c54a294be74c878d589acf52729dd4e1644f2adb97691040185cef2c9ff6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    bash_completion.install "contrib/completions/zoxide.bash" => "zoxide"
    zsh_completion.install "contrib/completions/_zoxide"
    fish_completion.install "contrib/completions/zoxide.fish"
  end

  test do
    assert_equal "", shell_output("#{bin}/zoxide add /").strip
    assert_equal "/", shell_output("#{bin}/zoxide query").strip
  end
end
