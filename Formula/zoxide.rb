class Zoxide < Formula
  desc "Shell extension to navigate your filesystem faster"
  homepage "https://github.com/ajeetdsouza/zoxide"
  url "https://github.com/ajeetdsouza/zoxide/archive/v0.7.8.tar.gz"
  sha256 "8590d755b06daf79309fb1798da3e87c0cbb51b44becec0e7db09d4ae5d1f670"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec89ce9f1e1176fc1af1be46c666b7b1b64358a55b955186410084ab15105254"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cb85549f67bdb7fc494bf7c1d59bfc595d510c277f01ec8cb1e0dc46a136c387"
    sha256 cellar: :any_skip_relocation, monterey:       "bdd0215d3ad9d0fe799fdb6d04830e6cef1737c2c3251eb8ce0584f529f90bc4"
    sha256 cellar: :any_skip_relocation, big_sur:        "498d5a0099ebe151eac10bfc0ccb7c02d56c60683f858ae3656cd2c4ab5b0f8d"
    sha256 cellar: :any_skip_relocation, catalina:       "ee86e34b0474e1a8a0fd314a6e763707fb014d1556c8b77e2dd9fbc890975bd7"
    sha256 cellar: :any_skip_relocation, mojave:         "3636dad3d34c0467b719da9191a8991e3fabe728a9e2cef7d5fd9f19d9bfb590"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "adf17c86b20fe4b3c9ab5c37d54bf7e84680073e60ff6e22a47aed6db9545469"
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
