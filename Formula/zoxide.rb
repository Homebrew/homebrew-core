class Zoxide < Formula
  desc "Shell extension to navigate your filesystem faster"
  homepage "https://github.com/ajeetdsouza/zoxide"
  url "https://github.com/ajeetdsouza/zoxide/archive/v0.7.7.tar.gz"
  sha256 "6c190f84e4d4c22fef6948b06afd451d67c558d5afee5225745fbcbe256b0194"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d78d2bcf6e51e41ffed61f23b3553d649e5d52a1063c95ff247bf7771680e90b"
    sha256 cellar: :any_skip_relocation, big_sur:       "a395f7068a4551cdcb970f177dd6b55fa9375e50c2a4da6daf08b37e7e90b7cb"
    sha256 cellar: :any_skip_relocation, catalina:      "9a0bd45f6d1a83857412c7ce9b2643543f4f4c0616bf36ee21a5b56935fe0f61"
    sha256 cellar: :any_skip_relocation, mojave:        "b5135a8b1703fd01e93db1bcf62c9c403c55a282ee67663fd1af42a9db52adaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e7bb2164c529594a197468507a9da08eb317524cb9891397fc0affd8301b396"
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
