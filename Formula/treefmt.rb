class Treefmt < Formula
  desc "One CLI to format the code tree"
  homepage "https://github.com/numtide/treefmt"
  url "https://github.com/numtide/treefmt/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "48554e1b030781c49c98c5882369a92e475d76fee0d5ce2d2f79966826447086"
  license "MIT"

  head "https://github.com/numtide/treefmt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e36fe5005a33042c3ce54228522d283457deedf874fdd5b37f7cca0ae6d30bd1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ab43b82b98d0895b80671222f2358a43b7da23efec5e1c08e5bd81fbb18b339d"
    sha256 cellar: :any_skip_relocation, monterey:       "d9ae614037e3cf4fbdfed41aa43d9bb92b500a0cd4b482a41d58731b2c3f61b8"
    sha256 cellar: :any_skip_relocation, big_sur:        "cd0e7c598a3bc722fc45a7eb855d369c166a14e74d06fe0fa3867752e72b58d5"
    sha256 cellar: :any_skip_relocation, catalina:       "c6b66734069db2cba8df597d2732376424cc186b90917a89de835ca8b86190d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9eb9b5430704c5e5b23f4c74eb31d40aa005ee4297e52f1c392d658320247b30"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Test that treefmt responds as expected when run without treefmt.toml config
    assert_match "treefmt.toml could not be found", shell_output("#{bin}/treefmt 2>&1", 1)
  end
end
