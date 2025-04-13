class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://github.com/jdx/usage/archive/refs/tags/v2.0.7.tar.gz"
  sha256 "e138f55ed912301a3b8c3d0db5354a8ebed71f4b3382750ac0ff57866a1a9b4e"
  license "MIT"
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "661d028582306d8c1bb19ab40bfa048e53493015bb12b170735d4684c083f40f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5887129aaf82b27c2bb4d6543c246f11cd55a9635b7c55c197918af0214786a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eab0c4d09a5d56fcbc4bfa80e9f7d209dbec3b72ebec4e5acc629a84c1aa1bf4"
    sha256 cellar: :any_skip_relocation, sonoma:        "4db6d986d36265f8b9c5970ffb9bfe5f692b102688ac031db5dd331dfa7c1185"
    sha256 cellar: :any_skip_relocation, ventura:       "b09518bdf8bb5925efc012593b3bbd8927f2cfccecc316f825f82c4e67c6f8bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11789b94abf75d43ec5e58d3a15cbf66eddff7f066a7f164c50a7fe70941108b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23eec25f4ed76803045dff996bbf5641b97ee5ec19bcbc1098f331028cfee7ec"
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
