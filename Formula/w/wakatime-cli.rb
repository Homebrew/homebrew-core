class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v1.139.4",
      revision: "43420d845e66970c2c77d2fcc01f7d970e4d9a85"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "810645cd02f65f250aeb42c6439b9aec1ed2589e9cdcb6b5dcdd954f0461efa4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "810645cd02f65f250aeb42c6439b9aec1ed2589e9cdcb6b5dcdd954f0461efa4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "810645cd02f65f250aeb42c6439b9aec1ed2589e9cdcb6b5dcdd954f0461efa4"
    sha256 cellar: :any_skip_relocation, sonoma:        "a040e00fd6bc7ee2749cd35f40add38b79c19e6e68aa94df4bf10820254e7a10"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26b35120d192709699d46707579b012d178822656229bb40be2ecc55561bfd8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72b6a1b5fe44402caeddec181b1e8b0c48375be53ea7f02c2183258f299da9b9"
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
