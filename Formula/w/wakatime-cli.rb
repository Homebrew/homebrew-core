class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.2.0",
      revision: "6d1423fde6b40f3d291cdf3681ed33ce9d699b6f"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d74197f2b6d873fe7cfc4471882fc5ef0f1d066494fb0c7e07fe743ca5461e86"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d74197f2b6d873fe7cfc4471882fc5ef0f1d066494fb0c7e07fe743ca5461e86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d74197f2b6d873fe7cfc4471882fc5ef0f1d066494fb0c7e07fe743ca5461e86"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d470690dcfb8c0e1f12b2ab8cce0ff62964c6b241b87ce73b0db3b7f6ee65b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49a27035e12f5eec33033f1da53db1746313d0d596ec83e9b060c86eff30669d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5382765a41b71193f8fd0ac7694e21886bef3825e4a933c4635aa6881a2f4ca"
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
  end

  test do
    output = shell_output("#{bin}/wakatime-cli --help 2>&1")
    assert_match "Command line interface used by all WakaTime text editor plugins", output
  end
end
