class TryRs < Formula
  desc "Temporary workspace manager for fast experimentation in the terminal"
  homepage "https://try-rs.org/"
  url "https://github.com/tassiovirginio/try-rs/archive/refs/tags/v1.7.17.tar.gz"
  sha256 "67574410ebbb1f6dd8a2cc7426c387d45df35da1df9670873ce999dc6f71315d"
  license "MIT"
  head "https://github.com/tassiovirginio/try-rs.git", branch: "main"

  bottle do
    manifest_sha256 "b638eb51b077dd1a942d16fe977f627e8a060799fa6bcd0b3c253bef68b204a4"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2a8c5028ba10d362346c850e852c9e91743faafabd7b686b1fcc5955f1003461"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "10ed064e3e890c1d4b1b2d390ced3fca55dc91108f0bf232487269c0d728937f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fb99258ed3bea096fadcb2f028094483f5acdf621e60d9b319150a53f507260d"
    sha256 cellar: :any,                 arm64_linux:       "a66f52ca356dd725676cb3996840eba0dfbe517fb13a57f8a3cb72414f920c20"
    sha256 cellar: :any,                 x86_64_linux:      "24c5ea626d9e0a274cffb598deb190bbbdb204cdadd521bbb6c2b1e5a065b12a"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/try-rs --version")
    assert_match "command try-rs", shell_output("#{bin}/try-rs --setup-stdout zsh")
  end
end
