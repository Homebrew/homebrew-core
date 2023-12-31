class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.88.0",
    revision: "c5f84f4c2dce1bd7740f0bcceb2fe4f59e0b8610"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9a9344f68c4630cf17c02ab750c6667dbab5b18c16e58de5e945a947354a2e71"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a32841fb7c1d181b306fae475903a59e4fd1f235b2485a0ef467cedbdb70753e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "856139e58ed9e436dca5a1848683d56d82132a8d57bcca9d755200300e6691d0"
    sha256 cellar: :any_skip_relocation, sonoma:         "9d38086bd32d43a7ae631352f2e32d55fa927b0f587627745cc85656e718ce57"
    sha256 cellar: :any_skip_relocation, ventura:        "8a7515c6390ad4b191fafab22570ad7aba74d8e0d4ea9cd76e9fe3ac4c53f3de"
    sha256 cellar: :any_skip_relocation, monterey:       "0c2f7450e2ba83ad57abef4686b779e150df1f59777345619fbd5741f869ee3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac001c28ea64d127585b02d2e270549f2a8bc2e96e4ffa778d94ab37531c00dc"
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
