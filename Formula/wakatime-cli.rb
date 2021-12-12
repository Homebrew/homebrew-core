class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.30.2",
    revision: "708e1b352aa93b8c18a0221a04a35669e4f5bed2"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af97057a32b427bb72f12ca431c64767b34e0dc4ed81dc5a997891a41ff00b46"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cd06840c3b8ccbc2f1e0fc6ab6d3f12327edd23cca99a78f5b36e9b20ab73f72"
    sha256 cellar: :any_skip_relocation, monterey:       "7f491587908990429462a6fc4996ef095dbd86bfdc1b92ff93ca588ac948bea8"
    sha256 cellar: :any_skip_relocation, big_sur:        "0fe10a28981c35818c530485d7427e0a9b2aecc9a1729e48e5c5bf6bd6f50bfe"
    sha256 cellar: :any_skip_relocation, catalina:       "b95cefb94aa3737c7095579f198962ebe84ce5a78197a11bc0cb970b1810e877"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "463b243185a88836bc1712d93e472d0b20829dd3dbc7bfcdd62485d8ab77f745"
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
