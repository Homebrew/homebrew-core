class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v1.112.1",
      revision: "eb8d10dcdfa53887ce53f148e57f701846066602"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62d6a92a125b1765aa201e9dd7b7eae4b6589da9f08c49b9b4999ec7db77c65a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62d6a92a125b1765aa201e9dd7b7eae4b6589da9f08c49b9b4999ec7db77c65a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "62d6a92a125b1765aa201e9dd7b7eae4b6589da9f08c49b9b4999ec7db77c65a"
    sha256 cellar: :any_skip_relocation, sonoma:        "0caf3603bc6987d480c1dffbd1e4027fab87035503936bc7cff06a5539e58700"
    sha256 cellar: :any_skip_relocation, ventura:       "0caf3603bc6987d480c1dffbd1e4027fab87035503936bc7cff06a5539e58700"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "690cc00c9b1687ab381c64b4b2ae9e8e640c5516148a167b7056668aec989480"
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
