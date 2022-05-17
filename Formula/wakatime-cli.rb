class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.45.3",
    revision: "f8796c22a6c14056c71eb41d6a22fe9eac2cb2d8"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "131ef53a8bcb201bf8f86fc950759f36f137e95d4626b1bbe309120b32d00bd0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "42c67f41b98db299d9bcf13b884cb90e27f2d0d2ed2447b64b24213818dbbedd"
    sha256 cellar: :any_skip_relocation, monterey:       "1639c41376ec65b3a5a6dfdfe282f74a0f1f22b33dd7ccca691294376ceb4c53"
    sha256 cellar: :any_skip_relocation, big_sur:        "aae2cd389644792ef05110f3b930fb85797921c8a5f2a27147fba0d475634a79"
    sha256 cellar: :any_skip_relocation, catalina:       "1878a128a1d4746ceb9585945627fc9d861e5703417b7997254040974fa7d4ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "425e1e73cfc9e38a107819eabde135eb26274ccea1d3c55afd1df5bd809f0526"
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
