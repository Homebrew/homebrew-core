class Zoxide < Formula
  desc "Shell extension to navigate your filesystem faster"
  homepage "https://github.com/ajeetdsouza/zoxide"
  url "https://github.com/ajeetdsouza/zoxide/archive/v0.7.3.tar.gz"
  sha256 "0b596cf8f86c51cc5aaf8914f8e47fdb0a60ba44e55d75a3d131b1f583ea098c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "26077ba626f3b9ec3c3dc0f93e2090f7ec79faf32976ea88da544c31cfa89b41"
    sha256 cellar: :any_skip_relocation, big_sur:       "9fa2b6907b0a46a92d718e150a5a313e5f37d0e3cdb53d9698e539a68f365790"
    sha256 cellar: :any_skip_relocation, catalina:      "fc9759e89813f1a0b16d5de08aabb9bb5ef0ac0a84a65d0e48da2326ad0a669f"
    sha256 cellar: :any_skip_relocation, mojave:        "764b02491f1029af600baea5c2af29c1ea9abe1bb5656f50d2251c238bf35d9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "004d8ab76ae2132003591667ac6bd60e6b63cf56e31ed5a78302fa2a4e8f8bae"
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
