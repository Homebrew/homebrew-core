class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v1.137.1",
      revision: "efca6429d5aa063cc7f667f17617076f935b48dc"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70aa7a4e7afdf7808068017c5a420c377831b2f0e6f07d3d4f7bea7a0e491005"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70aa7a4e7afdf7808068017c5a420c377831b2f0e6f07d3d4f7bea7a0e491005"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70aa7a4e7afdf7808068017c5a420c377831b2f0e6f07d3d4f7bea7a0e491005"
    sha256 cellar: :any_skip_relocation, sonoma:        "7cde789aacea571a090b529ccd2e775cbd7013af60027d05af7846061462c18e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee90f453e4edc2d0e1aba3f2cd23b487b28c2ede382bfa6fe431ba7823312812"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fb2fd6a1e058a76d1aa858c6df37951aaac6f310e369e2042e6f033998dba0e"
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
