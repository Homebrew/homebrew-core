class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.84.0",
    revision: "20cd2679bb757f9ec3defa0589954bd0a646ac94"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4d88a22426bd0281387a1d026ece500386413ffc4d77db514b3118d7bcb8fcb0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b3204870754d1125c6ac1aa44ea25fb794068a17c13302ab065112d8e1dde777"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f63ee641a873a4cf0c41ce2bb0f21c58b105a29a0d479ab819b5594769218c2"
    sha256 cellar: :any_skip_relocation, sonoma:         "23f3a08100416932ffc8f7aeff33c93f85975385e913b3f4cd53249cb129d009"
    sha256 cellar: :any_skip_relocation, ventura:        "895c51e86a52ba9600b8f100324cb29cac330f29a3701d9f648214a2299f1817"
    sha256 cellar: :any_skip_relocation, monterey:       "9aecd7fe38eb79db6c1fbd196931197aae009aae26a42563afe9f7d619390e4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a46885d28464a570585046ae1ce0b4447b087c3fda7f76096341f12dd5724a40"
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
