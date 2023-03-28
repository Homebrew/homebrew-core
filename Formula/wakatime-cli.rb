class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.70.1",
    revision: "ac825e98090967eb3e0eb5848e5c73b7d82d3566"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b438967d7ff7a842b1740bc0d0f9d5e4eaa4bc2e012d3e6c0a486b3b76766fa6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b438967d7ff7a842b1740bc0d0f9d5e4eaa4bc2e012d3e6c0a486b3b76766fa6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b438967d7ff7a842b1740bc0d0f9d5e4eaa4bc2e012d3e6c0a486b3b76766fa6"
    sha256 cellar: :any_skip_relocation, ventura:        "f9b902bc0706bf229733bef1774c9beecd6010c361e521e6388511e0d879a3a6"
    sha256 cellar: :any_skip_relocation, monterey:       "f9b902bc0706bf229733bef1774c9beecd6010c361e521e6388511e0d879a3a6"
    sha256 cellar: :any_skip_relocation, big_sur:        "f9b902bc0706bf229733bef1774c9beecd6010c361e521e6388511e0d879a3a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ad1392d1fc545ea4dc3c959e11e02d26865ba8c06de815bdad8049f991d0d40"
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
