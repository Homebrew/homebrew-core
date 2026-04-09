class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://github.com/jdx/usage/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "cc76bc1533f572ba9aa6145df0130e5b74d9cbdfb0631d20fa97224c2117bcfc"
  license "MIT"
  compatibility_version 1
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "16a104ea363b2d4af143039c9a50fc8588574b15c93a378fd317728746f6545c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f62872c22e3d678fdd9cf4cd84aa6704fe89c139385847daf83ec6563435a863"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9bd325e9cd9ae15e850f9dc1035713db34df0a415912535644d3ce3b03121319"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ef5c3b352efb99c8ccb87bed44a687770939f1520045038560381527cc7dd20"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f06b3ce600053c1dcaf9ff6d76d6e53ae6a357169ea6f3651a1781d3aac8fce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2fe4b193c8ca36e652c88befcd19eb5bce3299a3c4b50d5e932d6a09e3b4a02c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
    man1.install "cli/assets/usage.1"
    generate_completions_from_executable(bin/"usage", "--completions")
  end

  test do
    assert_match "usage-cli", shell_output("#{bin}/usage --version").chomp
    assert_equal "--foo", shell_output("#{bin}/usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end
