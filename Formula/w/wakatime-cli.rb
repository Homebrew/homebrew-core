class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.7.5",
      revision: "a5352d7fe0c6f3d899d972d45c0429d76778e1a3"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dbdc1685aa8e5f5e4c9126da082495dfa086465ca1232fd6f727a7262b1f18ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dbdc1685aa8e5f5e4c9126da082495dfa086465ca1232fd6f727a7262b1f18ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dbdc1685aa8e5f5e4c9126da082495dfa086465ca1232fd6f727a7262b1f18ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "c63311d663c41214668ee1e84aab8cc68dff2e7979f981224f88046a3a9ef24f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18294a472c1945332ac0dcba57ee88c516e811e14c5de07d3eebebd8ec64e0e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87702fdb861976c46a96f07cee25b25f05b746bd14771d60ee4f7f5dd89481dc"
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
