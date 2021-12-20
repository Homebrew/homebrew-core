class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.30.4",
    revision: "b412597086a58ba27b6895b84b337df56c8fe999"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d453754b067520b0e8de3dd52659a2811a227a4e4fe4bf1b2378442b140947e8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dbd62dd343e52d3d0f16f0ee13aaa26782b712851e44c5e80c658e60b6c281d9"
    sha256 cellar: :any_skip_relocation, monterey:       "cfccf02799fc34a95cc14cdc122d33e333801d0778b3e62ad23098a63fb563c1"
    sha256 cellar: :any_skip_relocation, big_sur:        "bd5b396c0f14fe721fee0dafe89a26c617ff02902cb37db0fa50f853eb7510c4"
    sha256 cellar: :any_skip_relocation, catalina:       "fc1331d0d4f8cd2dd99651fab292fb76b58dc70e42d5bf024677839c62e9d3aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c48c8acff01cb19dc874fd89d590fa87bb67d908c9ca08296f9655367b96483e"
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
