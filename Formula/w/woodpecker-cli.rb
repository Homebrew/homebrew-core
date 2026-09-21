class WoodpeckerCli < Formula
  desc "CLI client for the Woodpecker Continuous Integration server"
  homepage "https://woodpecker-ci.org/"
  url "https://github.com/woodpecker-ci/woodpecker/releases/download/v3.18.1/woodpecker-src.tar.gz"
  sha256 "21b3566b52d8a9f516ba162e21d2f2bcb0c80f9c0d54dc34ef33187e4102557d"
  license "Apache-2.0"
  head "https://github.com/woodpecker-ci/woodpecker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "eeeca24e1e54f3cdf361c02cd6892ed8eb1e101379bfd5b6e2cf83b9a93d88f9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "eeeca24e1e54f3cdf361c02cd6892ed8eb1e101379bfd5b6e2cf83b9a93d88f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "eeeca24e1e54f3cdf361c02cd6892ed8eb1e101379bfd5b6e2cf83b9a93d88f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "eeeca24e1e54f3cdf361c02cd6892ed8eb1e101379bfd5b6e2cf83b9a93d88f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ddab9692c51f5a8076378c6723f1ef6dfab9325841ce6c1e3fd7a13e3e0700b5"
    sha256 cellar: :any,                 x86_64_linux:      "3f02f87a35a5bebcf8b5ad479be589f78cd9299f9437afa411d1521cea97d761"
  end

  depends_on "go" => :build

  deny_network_access!

  def install
    ldflags = "-X go.woodpecker-ci.org/woodpecker/v#{version.major}/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"
    generate_completions_from_executable(bin/"woodpecker-cli", "completion")
    # woodpecker-cli expects "pwsh", not "powershell" so we use the custom shell_parameter_format
    (pwsh_completion/"woodpecker-cli").write Utils.safe_popen_read(
      { "SHELL" => "pwsh" }, bin/"woodpecker-cli", "completion", "pwsh"
    )
  end

  test do
    output = shell_output("#{bin}/woodpecker-cli info 2>&1", 1)
    assert_match "woodpecker-cli is not set up", output

    output = shell_output("#{bin}/woodpecker-cli lint 2>&1", 1)
    assert_match "could not detect pipeline config", output

    assert_match version.to_s, shell_output("#{bin}/woodpecker-cli --version")
  end
end
