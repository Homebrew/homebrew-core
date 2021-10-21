class Zoxide < Formula
  desc "Shell extension to navigate your filesystem faster"
  homepage "https://github.com/ajeetdsouza/zoxide"
  url "https://github.com/ajeetdsouza/zoxide/archive/v0.7.8.tar.gz"
  sha256 "8590d755b06daf79309fb1798da3e87c0cbb51b44becec0e7db09d4ae5d1f670"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0aea21ce70cda5cafef9cb089b0a478ce7ebc7ba6efcbdae76743029cae4693c"
    sha256 cellar: :any_skip_relocation, big_sur:       "4105ea85bff355e1d200743c370cf1fa1711027117724a647e1f9c00d070b2f2"
    sha256 cellar: :any_skip_relocation, catalina:      "fddfc327e08b33e3e21e923300d88d1434422341e33b0c4c97727234626ac95a"
    sha256 cellar: :any_skip_relocation, mojave:        "7fcf42d57714522557e3fec0de3bec943d493a853806232b201e0df34999412f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52f8eb2758daee62d735e3182ec42f2e2a330a1d43da8555d84c8702ae6a873a"
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
