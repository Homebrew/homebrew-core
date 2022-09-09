class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.55.1",
    revision: "b064b306cbd3b28d2f772c30ffa2654bb56ae84e"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "544271958fcea23c76c485bae8b3fb78eac10fe0462f572d8f6f8871bd0f0e57"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "edfe4520455be489ccb02a5ff50bc45ecb0df237bc711ad3ff93db6e59953155"
    sha256 cellar: :any_skip_relocation, monterey:       "a9eba8061030c52e6d43c76ad3ff2a1d1c94a1556217518f7888b76e3af05de3"
    sha256 cellar: :any_skip_relocation, big_sur:        "2b46432ef295139f165c85a96f30da0dab301c47256585f2d01f7bf84300aa4a"
    sha256 cellar: :any_skip_relocation, catalina:       "a8a1fa148eb7f87175d978f8a2eaf9550e9d5a6e569c15cf1ee2702f402e02e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2f7aa3dea5a90c4f180ce0a46a1efe9a46967270068e04cfb402ad79cc736c0"
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
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    output = shell_output("#{bin}/wakatime-cli --help 2>&1")
    assert_match "Command line interface used by all WakaTime text editor plugins", output
  end
end
