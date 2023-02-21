class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.67.0",
    revision: "b78dde53df3fb6d179dc2349fe7523bfb2854f37"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dcf8e4e6a07146d59a9c6523b0445c6760cecf67ac1bd1a24c8645af69b181bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75e27de9f63911e764117c17de5569598bb49e98e9beb75e49c1eb7196aac123"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4ecb77c874ea3139013c69a292ad5f82972480f9fc810f889ca02f257b30dbc1"
    sha256 cellar: :any_skip_relocation, ventura:        "0d0b855df15d1a3753552db0b3600d1f95c27413481df1d57136bcdce9464ed1"
    sha256 cellar: :any_skip_relocation, monterey:       "2754f6ec3444c207c13743179e900266149a340ff9ee038f963eb71ff7a6a9db"
    sha256 cellar: :any_skip_relocation, big_sur:        "bcd3319f324e53680fe5a57bec26cdc4c17b4de673f0a51fb96748dc2f395a98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64030cdfe9f8d6a9d45bd3007adec3a170217c58258242b725cca3aa0372169f"
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
