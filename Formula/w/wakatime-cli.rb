class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.28.4",
      revision: "9fee1b464bfbfae5b8409b6f68942be444f464e2"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b7dd6d3e46caebf26b299f4fddaacae7b261dcd2908e2d16016f5cf2762489d2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b7dd6d3e46caebf26b299f4fddaacae7b261dcd2908e2d16016f5cf2762489d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b7dd6d3e46caebf26b299f4fddaacae7b261dcd2908e2d16016f5cf2762489d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "067667fa1524ad84f9fbda8089e11e72ab7b3ec4d7633d57f043f4e8f7104f00"
    sha256 cellar: :any,                 x86_64_linux:      "9a5f7ef0486165975cab2db589f7ceb41e83855d3f18d7d758bcf49de58c531a"
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
