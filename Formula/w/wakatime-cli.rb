class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.90.0",
    revision: "cf90685bb615991d118f88cfe96b1306dae0557a"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7d0751a99e3b8d95d89bd8caeb82c2b32ffa521f760826c80d0ecdcedc754fb9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2d7eef07edd19b9c27ecfbb9a0abe3bc2b136121a1a83b1e87477ce23055b100"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91ea622d95c4ffa7cf125551787af5f7be3b13ab39967eb194e2a925744feac9"
    sha256 cellar: :any_skip_relocation, sonoma:         "683d871d74566e583557b66395bd1972b9374a65ccd481c8892c021c7d00fdec"
    sha256 cellar: :any_skip_relocation, ventura:        "7d24a356df4f8b9008ed4a247332f0c9a91794d017b764fbdef1e794c442f682"
    sha256 cellar: :any_skip_relocation, monterey:       "7c39afe3eeb13c72ce76a5eba4342838265a6e1ff3c452020f00341f4538453f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f762c949509e8bacf78e0cb5436ad8b27c6ead51ab53c62ae3358e84394971e"
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
