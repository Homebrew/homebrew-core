class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://github.com/jdx/usage/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "60c927e807099b809e38baed423eb6029886a39ced3e762f5df222ff455606f0"
  license "MIT"
  compatibility_version 1
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "524c46d338f8f3690484974f37f9f55b79cec05467b03806861b1402276cc291"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e61c6f59fcb7a2790071b8029401455cba056ed41a329ccd5116b303122931c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76accbc385dae562a98e8bf59700cc46c5043cefec3c6ae0b62dce27482ef813"
    sha256 cellar: :any_skip_relocation, sonoma:        "9faf93d23eb5c197de151571f320dbdefe693bec86d2dd84031f6cb576e174f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6bc569c488cbf502b4643713409f6a834d52010b49983d3c98462ac52020d2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e36199fca0ec2d591761098746355539e86e67ea504ad2bbcd6582b8b62ecb5a"
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
