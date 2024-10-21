class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://github.com/jdx/usage/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "8f78560edc47050649824a8f3990f0bce329f181a85101a4acc215c7b143d32d"
  license "MIT"
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "114b75a6cc3811e135c2aa9b5398da78fa6fe2d6cdbbfc61062b4a8ff6302501"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9808dab3638e2fbb4b8bc052a072bcc7cc2640cbadbbddadebaaf5442351a7a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fba5c51de45a9dc6e56f040621ccbdc0608efdf497c5b366dbf5110ee0b0d1a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "2cd685b7aab817179077539bf1e5c69e29734ad9df7a308be89bed28ce08245b"
    sha256 cellar: :any_skip_relocation, ventura:       "8b0c3b46220566138af97b3d4979ed178b5d4737d7c05949c8f06a67aca5b83f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e782231c2daff70836c02e7e93612f61717164917bd748617383cf8c058d0f8c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match "usage-cli", shell_output(bin/"usage --version").chomp
    assert_equal "--foo", shell_output(bin/"usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end
