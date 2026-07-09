class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.21.4",
      revision: "40bd51df71c2c434ae2b89f0301238796ccd671c"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f5dc7c3a598d4f848709fc41e4dbedcb9719acb40bfd95c56bd7d23f7a757c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f5dc7c3a598d4f848709fc41e4dbedcb9719acb40bfd95c56bd7d23f7a757c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f5dc7c3a598d4f848709fc41e4dbedcb9719acb40bfd95c56bd7d23f7a757c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "48f9441c9381444288baac8ef99459d83081c287041ab526c33cd7726d9566ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c7c7c7c26bcc846a8ebbc5aab396480927fc696174456a297fc164648f7fe31"
    sha256 cellar: :any,                 x86_64_linux:  "3a8454c4744afcacf68a0416c373426907f3e125c83cd0bad0dfc612b28d3a14"
  end

  depends_on "go" => :build

  def install
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    ldflags = %W[
      -s -w
      -X github.com/wakatime/wakatime-cli/pkg/version.Arch=#{arch}
      -X github.com/wakatime/wakatime-cli/pkg/version.BuildDate=#{time.iso8601}
      -X github.com/wakatime/wakatime-cli/pkg/version.Commit=#{Utils.git_head(length: 7)}
      -X github.com/wakatime/wakatime-cli/pkg/version.OS=#{OS.kernel_name.downcase}
      -X github.com/wakatime/wakatime-cli/pkg/version.Version=v#{version}
    ].join(" ")
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"wakatime-cli", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/wakatime-cli --help 2>&1")
    assert_match "Command line interface used by all WakaTime text editor plugins", output
  end
end
