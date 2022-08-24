class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.54.0",
    revision: "67bc07eb6e1cd2f4ede81faa8cdf53e2554327b0"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9c3409cdff25fbab63d0d27b435de27f3a686c5af743b6258c99443024c6ef4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4e07f1a0275793e1dbe947a6b31164a4910c49d4e7199f722f193d94ece275ae"
    sha256 cellar: :any_skip_relocation, monterey:       "9489529e83861356692c642dcc176453bd8dbb114369978189cbdb5905650225"
    sha256 cellar: :any_skip_relocation, big_sur:        "2abba446068fd03c799024f5e0b402be5b1ffef879408d8b44ef09145375c6ce"
    sha256 cellar: :any_skip_relocation, catalina:       "c9eb65ae50bb247c2808f198b7183d98923fe31e12e4712703ca5d84fc72af08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d86501961efa9200a15fe3cf89d0c3216fed8fc9e8beda62daccbb7487fffc05"
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
