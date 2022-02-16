class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.37.0",
    revision: "93c42c1e8a89ed2e95157edc475f2c6051e1e064"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6cecb39c3ca60b5626e87419823b452a106e2c169e18ee37382f2a19bc0eec18"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "46da81a2e03d29faa889c5fb619cdf1afc1ffd1439be9a4ea1bde0049f1ac94f"
    sha256 cellar: :any_skip_relocation, monterey:       "67f663719d1be18b4f2ccb8f044fa3440f9078b3c4c4f10c878d67523cc650f9"
    sha256 cellar: :any_skip_relocation, big_sur:        "4e56f82c49d982e2a0f767c1d8538b10a246ebe4af2accacb9b6e5452348590a"
    sha256 cellar: :any_skip_relocation, catalina:       "ffb823d1e79afb9c24cba04d1e690e40c19260afd8bca7ee978f3dc24ea31bd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f0f01b47a60f0f9b4dec5f15df6271cb8d9d538ff0de1a30f6dc74721d98872"
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
