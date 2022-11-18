class Zoxide < Formula
  desc "Shell extension to navigate your filesystem faster"
  homepage "https://github.com/ajeetdsouza/zoxide"
  url "https://github.com/ajeetdsouza/zoxide/archive/v0.8.3.tar.gz"
  sha256 "eb1839a4ab0ce7680c5a97dc753d006d5604b71c41a77047e981a439ac3b9de6"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fabb92b6d10a220689a314adcd7d94d10585a7243fdac41a70825f4a98281d7d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a04655e8974432dd241aef77a33aaf514f0a4b9569d876c7552e73a31b4a674"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "45fd44d2eb79fcc05e4ba14b7f789148eece72cb996842b9aa478466858f926f"
    sha256 cellar: :any_skip_relocation, ventura:        "fee8d8c837efb9cce1b9b7b5f706d72afab08eafe4a619693b47e008990f6368"
    sha256 cellar: :any_skip_relocation, monterey:       "d1baaa014412d638388f7a5cb7b3ed8704bbcb2277c0b6b09e2222c5fc204fc6"
    sha256 cellar: :any_skip_relocation, big_sur:        "d17d1b527fce22d7cc08e67276ccac8dce07188f77647adc1139c1dbe83dfd1b"
    sha256 cellar: :any_skip_relocation, catalina:       "0d95ed5c8cb92b344dde292c2932d39bc6efd2e6bb197b1da7c7349ba52f4f98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b68e7bf24424f1be96c8978b0bab394f7c1a341f74c603b98773b88b59a969d"
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
