class Zoxide < Formula
  desc "Shell extension to navigate your filesystem faster"
  homepage "https://github.com/ajeetdsouza/zoxide"
  url "https://github.com/ajeetdsouza/zoxide/archive/refs/tags/v0.9.7.tar.gz"
  sha256 "d93ab17a01de68529ef37b599524f882dc654835cc121a9097dd3f2952fd207e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dbc879ca84d59e01915fa207e20e98d936441aeed8b9147bf2689119d187700e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c654b9d6b2f165b320441a9d5f1b037706862bebda869d0e955ab2da7737358b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c34e507546f4c8de1d20a6cd324a02aa8596eb89b1ced7dfb308801b98f02f6f"
    sha256 cellar: :any_skip_relocation, sonoma:        "476964a629f3eaf86206fbb0c7019bb6d03da65fcded1a04872062470e567464"
    sha256 cellar: :any_skip_relocation, ventura:       "192e2ca56f343ab47ffa5a8375c8982fc4b617c22b8a5c141e258fc994c3d05b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b0e4294f535cdb98853835ba16a21d8d1faa2ecdf9c8393581c8fe0d515f669"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0f32731a4d1ff94848fd9b1f497381a515a44430af3e99ccf1e59ed11fe1619"
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
