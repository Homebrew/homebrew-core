class WoodpeckerCli < Formula
  desc "CLI client for the Woodpecker Continuous Integration server"
  homepage "https://woodpecker-ci.org/"
  url "https://github.com/woodpecker-ci/woodpecker/releases/download/v3.21.0/woodpecker-src.tar.gz"
  sha256 "c0c9735af9270472f5241a2af80bc8f31d884f4b955c6a5956606ccfb15eb1af"
  license "Apache-2.0"
  head "https://github.com/woodpecker-ci/woodpecker.git", branch: "main"

  bottle do
    manifest_sha256 "f40344fe910d93f8ee9470c9472608d63988c86d1cea493feac93556e7390640"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3b8e3b7c21065b9b9d2c2364b43ee141e3f92fed917b18b6d0d1bd769ab9c8d5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3b8e3b7c21065b9b9d2c2364b43ee141e3f92fed917b18b6d0d1bd769ab9c8d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3b8e3b7c21065b9b9d2c2364b43ee141e3f92fed917b18b6d0d1bd769ab9c8d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5ef09e67ca9d93af6a5602bfc3712874068fd07afac84277f2ecca47b62c1d99"
    sha256 cellar: :any,                 x86_64_linux:      "5e709dbf1d8ec38f247f1aaf14da5d434fc2fd99763abf3da34ec26935193c89"
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
