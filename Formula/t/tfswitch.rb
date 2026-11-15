class Tfswitch < Formula
  desc "Command-line tool to switch between Terraform versions"
  homepage "https://tfswitch.warrensbox.com"
  url "https://github.com/warrensbox/terraform-switcher/archive/refs/tags/v1.20.0.tar.gz"
  sha256 "9cc776761add1d3a07f55db5ae0e53834341ec7b1ae8ec2dfa4e748907350761"
  license "MIT"
  head "https://github.com/warrensbox/terraform-switcher.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "06217960f63d5f3288ddad26fa7953f942ee693c3d8889a2547e1f8e67a7d30f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "06217960f63d5f3288ddad26fa7953f942ee693c3d8889a2547e1f8e67a7d30f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "06217960f63d5f3288ddad26fa7953f942ee693c3d8889a2547e1f8e67a7d30f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8518581935fc8ba45c4a6fd15bc6ab86ccb81ba83d6557e54b47d0293f609798"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "c60c8a1f653d3a397836fc6e4720011245d929d5974d6bd8cf706277ca9d8b20"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "0"

    system "go", "build", *std_go_args(ldflags: "-X main.version=v#{version}")

    bash_completion.install "completions/tfswitch.bash"
    fish_completion.install "completions/tfswitch.fish"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tfswitch --version")

    (testpath/"versions.tf").write <<~HCL
      terraform {
        required_version = "~> 1.5.0"
      }
    HCL
    assert_match 'Version "1.5.7" matches requirement "~> 1.5.0"',
                 shell_output("#{bin}/tfswitch --match-version-requirement 1.5.7 2>&1")
    assert_match 'Version "1.6.0" mismatches requirement "~> 1.5.0"',
                 shell_output("#{bin}/tfswitch --match-version-requirement 1.6.0 2>&1", 2)
  end
end
