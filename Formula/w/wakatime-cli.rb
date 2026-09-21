class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.26.5",
      revision: "a38bcde45fa3d9f5f40f1c1c1e8bd008ad96b070"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "167a96cc52b63b47e4b99d4c01779cf114632aac79e67d098ca2d2d7331b1916"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "167a96cc52b63b47e4b99d4c01779cf114632aac79e67d098ca2d2d7331b1916"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "167a96cc52b63b47e4b99d4c01779cf114632aac79e67d098ca2d2d7331b1916"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fb1a45f1330b889844f3b099c262b65e6bd8e0ed2081f34dc930a0381c2a1429"
    sha256 cellar: :any,                 x86_64_linux:      "023030948b4f6dca4a034ee6e70aa470f470412b194e1a3ea75882481fbf7038"
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
