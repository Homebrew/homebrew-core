class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.35.3",
    revision: "f55a26c4350acb1cf8c92d4a3a6944a5d927a6a7"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "906fb0174cc54da00d681d3992a75b96a4a2fffc7ec24a1741363f38b8ff48ef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d7fa347aede6d84072f7e7f17ea485f7f0e99b1f69c356b6cf6e60ce4ae24b88"
    sha256 cellar: :any_skip_relocation, monterey:       "bbfa9dc3ba8e79f728ab459b3d5ba495ce615eabbbfe4372890fc0ffa61b096d"
    sha256 cellar: :any_skip_relocation, big_sur:        "9fb521535fc571da68463c75a276576f3a6a7709a1027367061a9014c7d67f8d"
    sha256 cellar: :any_skip_relocation, catalina:       "c456b67502894360fdfcfb02e6f027eae230ac9ab34f655c699ccb7cdf5cd984"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "021bc12a0dcff15beeda94c29364a4d66593a9c918a24c580473340099e82b17"
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
