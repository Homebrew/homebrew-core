class Zoxide < Formula
  desc "Shell extension to navigate your filesystem faster"
  homepage "https://github.com/ajeetdsouza/zoxide"
  url "https://github.com/ajeetdsouza/zoxide/archive/v0.8.1.tar.gz"
  sha256 "89002fe436b2a268b84a7e651cfd20d4b58ebc021c4e41d650af072d1c09f1d9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b2d16f68c91366e37c2e43b848e0c60c1ba1acc0439e526a404fdb598997b31"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "505d07fcd2b5c2b0dac778f5453a6e619c4dfd79d8b4e715c57ca61384afb527"
    sha256 cellar: :any_skip_relocation, monterey:       "dcf89db8e4bc31ea079217991fb8c60604b5b5f5b472395de3c161a288aa901d"
    sha256 cellar: :any_skip_relocation, big_sur:        "9e3dbe9ce30a09ff75a61d88fe1f6e3b825d8953517e5cad3a1c938ef9c6898e"
    sha256 cellar: :any_skip_relocation, catalina:       "c546ee501c536e5fd210f64f75b7c6c097cb5334e798647d5e6b22c320c10147"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4595f05c5f6ea9dde7920ef72037e167850cb4e734466ca6d3c784409cf16f06"
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
