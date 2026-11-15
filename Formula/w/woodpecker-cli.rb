class WoodpeckerCli < Formula
  desc "CLI client for the Woodpecker Continuous Integration server"
  homepage "https://woodpecker-ci.org/"
  url "https://github.com/woodpecker-ci/woodpecker/releases/download/v3.20.1/woodpecker-src.tar.gz"
  sha256 "ba26448df1fbf131b0aa15edccdbbffac5cbcf9d201c1ef1e4fd630d4ba98327"
  license "Apache-2.0"
  head "https://github.com/woodpecker-ci/woodpecker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4865c294f4f5a342cd3996b74a495bc9afed6ac739a530164910a6a099d94fda"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4865c294f4f5a342cd3996b74a495bc9afed6ac739a530164910a6a099d94fda"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4865c294f4f5a342cd3996b74a495bc9afed6ac739a530164910a6a099d94fda"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c6493a6fe14fb0a643a810a1efb4f68a8538c6d00e6f928d5c3811796d8ad271"
    sha256 cellar: :any,                 x86_64_linux:      "3d087346b7840e0f349d15e221114ddbb458670f11f4020af0c2dcbc54a5ea32"
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
