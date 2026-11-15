class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.28.4",
      revision: "9fee1b464bfbfae5b8409b6f68942be444f464e2"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4b1ee21e0160316b220da54eb1bec3f47dfab8b4ead008557cadf1d5c2f19c73"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4b1ee21e0160316b220da54eb1bec3f47dfab8b4ead008557cadf1d5c2f19c73"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4b1ee21e0160316b220da54eb1bec3f47dfab8b4ead008557cadf1d5c2f19c73"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ecf45d475617ca5cb8bae36bf3d2de424c7e330f4a9935cbd8f49e679f4af942"
    sha256 cellar: :any,                 x86_64_linux:      "7a9876760117a5115a6dcf058b34f1d6394927f8ac1ad4c101055b7996326ae1"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    ldflags = %W[
      -X github.com/wakatime/wakatime-cli/pkg/version.Arch=#{arch}
      -X github.com/wakatime/wakatime-cli/pkg/version.BuildDate=#{time.iso8601}
      -X github.com/wakatime/wakatime-cli/pkg/version.Commit=#{Utils.git_head(length: 7)}
      -X github.com/wakatime/wakatime-cli/pkg/version.OS=#{OS.kernel_name.downcase}
      -X github.com/wakatime/wakatime-cli/pkg/version.Version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"wakatime-cli", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/wakatime-cli --help 2>&1")
    assert_match "Command line interface used by all WakaTime text editor plugins", output
  end
end
