class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.2.3",
      revision: "b9eeb2b14cf273aa2cad1f77a08103f30916af79"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "83d7c034435e39c9cd8392a06ac40ec49de84bf6ce9bae011285d6eaefbfda33"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83d7c034435e39c9cd8392a06ac40ec49de84bf6ce9bae011285d6eaefbfda33"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83d7c034435e39c9cd8392a06ac40ec49de84bf6ce9bae011285d6eaefbfda33"
    sha256 cellar: :any_skip_relocation, sonoma:        "c13732820f663322e4c6154127b337c8d9b216049d17628c2260cd27580b7934"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de90d25f1eb151922934b357f0f67a64751fe0fbd2e441411632793afcb82727"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d18ccb331e6cd734f3d9d1b13087a61cade3ac2acb022e9a9eb1d89fd9b0ef0e"
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
