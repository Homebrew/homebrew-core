class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.40.0",
    revision: "144cb9962a47ff3a2b24586236cfbf276565a39c"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a84ae92fcf6d35980adc853b3712e6c15b71fabcd67f840daec1531df8390fd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "60bf24f7026ef3903637ae7ba7711f031e2562bf9584705aebafc884cdb57ff9"
    sha256 cellar: :any_skip_relocation, monterey:       "1edc5cdf6fa87ed548807bc4bcacdbf526d2083920ab086fb19f15ed25951449"
    sha256 cellar: :any_skip_relocation, big_sur:        "f381a7534f6ab48fd5954449b4040b4522a54f5b8cf9349baaf8a9b087346002"
    sha256 cellar: :any_skip_relocation, catalina:       "e6e4515d72eb5d7a4f854a499a9b722a32a208496ceab0f0552b1218973c3e38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30400eeda31bda56e472c5eebe528b5c47de62a9ff5cf2598b3d875e0d0d3631"
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
