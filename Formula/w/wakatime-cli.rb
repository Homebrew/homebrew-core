class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.78.0",
    revision: "881d6055b30a31cb6cb3c33ab394db46bc8dd98a"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd728a4a6265f65433cba9b76a2666cb7d8160b4e6eb3ac1dcb7948d7ff7c3e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "211c2faf74b59d36ac228a68c764211b8cb12dc0f6854e813f1a385b3d2ce4bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "46041fc2dc74d1f672e24e527366d0a62d29b69d5872ae057d61d8e534b9ef5a"
    sha256 cellar: :any_skip_relocation, ventura:        "578439cdc0982387137dc3dfece1607df4b3e9339dfc7d4e3add42893d6ed448"
    sha256 cellar: :any_skip_relocation, monterey:       "7a577631adc4ae3e6403c439dacbcd096e4c4e0bbf21a01db99346cb94e2ac0d"
    sha256 cellar: :any_skip_relocation, big_sur:        "1f75d613d2f493ede6fa72a1a6dfdfc50849af3e891a5fe46fb79645089d089c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c46aa4300f67b99e8bf857ad17521f4066ed15726c2e73f4848743b32d3f8e7"
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
