class Zoxide < Formula
  desc "Shell extension to navigate your filesystem faster"
  homepage "https://github.com/ajeetdsouza/zoxide"
  url "https://github.com/ajeetdsouza/zoxide/archive/v0.8.2.tar.gz"
  sha256 "3a977960284bc06f3c7f02ec93b6f269fd9f5bf933115828e6f46cf6c2601f5e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4cdc7e519771286cef66580c336d36a464d694a528793dce9c8e48016667f2d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cb48744aa267bc52bccc4b610bfd7ae1b6fa75006b5259ecfa66c7a74bc5249d"
    sha256 cellar: :any_skip_relocation, monterey:       "f88ad659d706245b0b6e7c317b8c96e3566f013eb45f2a4a55d56e8e045126bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "486dd1713034921782f6c66c6a6e1aefea95a62cfaed21d7597868e376085c19"
    sha256 cellar: :any_skip_relocation, catalina:       "71a8f9f3c9e7724ea2466d98f29d9c7241e8f296a3aa95d8911e81de54e76cb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17ed1ebc50f44d8c232c09d39e8a09611ac3b99b0cce38f7b7a6f4223135f4e8"
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
