class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.26.2",
      revision: "184cfb91d54153c3a4a57ed0703d340a0159cd18"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "156d89d24979ad361fcd8aeab53924bc6cff180e2fc9bdf6c7149cd77da2a42a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "156d89d24979ad361fcd8aeab53924bc6cff180e2fc9bdf6c7149cd77da2a42a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "156d89d24979ad361fcd8aeab53924bc6cff180e2fc9bdf6c7149cd77da2a42a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "41d379a29db55af139572b0a64fab18289f1c0ef77c7a86d305a3db82d03cdf0"
    sha256 cellar: :any,                 x86_64_linux:      "42ae44dcfadad45bd54ef1b428d481b1ebb7099c31ea273d12de2c25f0014e89"
  end

  depends_on "go" => :build

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
