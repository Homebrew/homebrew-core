class Zoxide < Formula
  desc "Shell extension to navigate your filesystem faster"
  homepage "https://github.com/ajeetdsouza/zoxide"
  url "https://github.com/ajeetdsouza/zoxide/archive/v0.9.1.tar.gz"
  sha256 "7af5965e0f0779a5ea9135ee03c51b1bb1d84b578af0a7eb2bd13dbf34a342dd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "472a9ffc7bc9ff61e9d2e1c8413d5b86a132a788c5eb28f664541daddfa52314"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ac231eccb9892718112276ee166dc77d8f4e8ffd2d8b21fd05b41a561ece5d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "88c424879c1a06e35038bcd3f0f634f6b43f8fb5850711bf21d857eedeb758fa"
    sha256 cellar: :any_skip_relocation, ventura:        "47b2114ab5c2316211695d1a4008aa51cfbb755b794f52529631695fe06d527f"
    sha256 cellar: :any_skip_relocation, monterey:       "9dd9d92d6f543ec59a135a824d794c472267185646c1929ff5339edbb56bf2f3"
    sha256 cellar: :any_skip_relocation, big_sur:        "43f7963a4d6b0c9b15fb90691a86a5fd9bfd2cffbdb7555c67f4e0eddbbc6240"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa5a15864f91c8b3a966e228824a046bff2a4736df3aa94f57d8efe21fc53f8b"
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
    assert_equal "", shell_output("#{bin}/zoxide add /").strip
    assert_equal "/", shell_output("#{bin}/zoxide query").strip
  end
end
