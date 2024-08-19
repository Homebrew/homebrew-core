class WpCliCompletion < Formula
  desc "Bash completion for Wpcli"
  homepage "https://github.com/wp-cli/wp-cli"
  url "https://github.com/wp-cli/wp-cli/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "fe8ab96e573cc33f86e7031dee39ba938af7d5518a9031055c8f8d799688251c"
  license "MIT"
  head "https://github.com/wp-cli/wp-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3ad157b0837b4892d9055baae3119a771dc55db7b16d4284c24a86b393c1bef2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ad157b0837b4892d9055baae3119a771dc55db7b16d4284c24a86b393c1bef2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ad157b0837b4892d9055baae3119a771dc55db7b16d4284c24a86b393c1bef2"
    sha256 cellar: :any_skip_relocation, sonoma:         "3ad157b0837b4892d9055baae3119a771dc55db7b16d4284c24a86b393c1bef2"
    sha256 cellar: :any_skip_relocation, ventura:        "3ad157b0837b4892d9055baae3119a771dc55db7b16d4284c24a86b393c1bef2"
    sha256 cellar: :any_skip_relocation, monterey:       "3ad157b0837b4892d9055baae3119a771dc55db7b16d4284c24a86b393c1bef2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be7a910d7b1851d7ba346ccd1e5cc7d043c0f88e397f0a6c93fd3382bd0153cb"
  end

  def install
    bash_completion.install "utils/wp-completion.bash" => "wp"
  end

  test do
    assert_match "-F _wp_complete",
      shell_output("bash -c 'source #{bash_completion}/wp && complete -p wp'")
  end
end
