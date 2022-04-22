class Zoxide < Formula
  desc "Shell extension to navigate your filesystem faster"
  homepage "https://github.com/ajeetdsouza/zoxide"
  url "https://github.com/ajeetdsouza/zoxide/archive/v0.8.1.tar.gz"
  sha256 "89002fe436b2a268b84a7e651cfd20d4b58ebc021c4e41d650af072d1c09f1d9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76e75d3d5565b7bafd76e3a7bb1063c87fed73589e68d4f6864e9bd4900a5bc1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eebbc874b003196e9ed654a4eb5a4d914b8971d481a18d8d98e0749fc924e2a3"
    sha256 cellar: :any_skip_relocation, monterey:       "daf84d01673d87f8f983524032b0f96019414d03a1b3456a5f139ab94998827a"
    sha256 cellar: :any_skip_relocation, big_sur:        "1689af2cdd2fe3114330b670fcd9c8e5e89d8a8fd846c9760f4c4662676e794f"
    sha256 cellar: :any_skip_relocation, catalina:       "6000cb2d7e897ffa61540520005f61f04dab5bff62e1d7ff6dee4934f43c1b23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbb12afba1e279e080980220b86382a285e2cbbf6fc40e8f9129ec01c79ca8f5"
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
