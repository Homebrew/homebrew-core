class Zoxide < Formula
  desc "Shell extension to navigate your filesystem faster"
  homepage "https://github.com/ajeetdsouza/zoxide"
  url "https://github.com/ajeetdsouza/zoxide/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "4fcd4272b013a10b637dbcc299c58a9924b94470a9042677ca1a204cc2e9150e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc0c0099a4fa529d296ccb9e295e1816ded39a89ab816ba7fccec2e739f46974"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9547dc2a1830e3900f7915b47ac7fa42a3d2d5ee9b125007e7e860920d0e899f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d7fbfa1e878ceefbc5fd0c3d97b8e9c1ae54f81ff79354fa792b59875391818"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3c9b69ac0b3d814619be69d32acfd5416d9e082ef5cddf21c698a5e0ae90ecb"
    sha256 cellar: :any,                 arm64_linux:   "e49cb48600200939509b9d1171c041e36f9d93a5b49559b80ae6279940c14861"
    sha256 cellar: :any,                 x86_64_linux:  "2c8a3b3c72267d9ecc0ba764e9338ce6da34dd8eaeb828743f025c9d1c94befa"
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
