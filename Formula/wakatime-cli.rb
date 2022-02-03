class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.35.3",
    revision: "f55a26c4350acb1cf8c92d4a3a6944a5d927a6a7"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d881ec44e63fb4635a42ec090e09d2c09f01f3e9c80e03738a01c970536cec3a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "569b9a6fa4dfa51597f3375f66bd9c7f5a7b7b615c8ea830849ea2372146d420"
    sha256 cellar: :any_skip_relocation, monterey:       "dce1ff1abfab5a2d12828ce2847f0dd2f264d9a0798cdd6b9b1a9c9d22bb0956"
    sha256 cellar: :any_skip_relocation, big_sur:        "a1fcfefd039daf009cda120b0a32149c2c8beeab6e7e6ec0b68a52edcdc6f8c8"
    sha256 cellar: :any_skip_relocation, catalina:       "049f5cb89778e79b3fdbf57b3ce75a9f0b9a093598523d1f3f354d764ca9dab7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0780f12cc102175a00efef47ac08880b719bc1d3a2d5d57a68a26cb3c3061db6"
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
