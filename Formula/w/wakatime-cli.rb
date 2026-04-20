class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.6.0",
      revision: "b361c3e9b491550688070ce6c3f555d03d8fb495"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d99aaef9667bbb91a59d4c4ab0765498432c94f81090354cc5cdc584d1bafcd7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d99aaef9667bbb91a59d4c4ab0765498432c94f81090354cc5cdc584d1bafcd7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d99aaef9667bbb91a59d4c4ab0765498432c94f81090354cc5cdc584d1bafcd7"
    sha256 cellar: :any_skip_relocation, sonoma:        "53b1d22ff139727d9a9ae0c38da50e929caab2f35d60c4549ad64c237f83139d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96080083bad5fa19cd665718cba4eb1dffb12d74356106fe1ae49942b664d6a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1f5c388e6708422e2415b2341df1e9cc01e0b6fe7eb3d9590c1a3be486cd225"
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
