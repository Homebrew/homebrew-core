class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.35.0",
    revision: "15895a5d2229a0e72906fa897cab5bd6314a3d96"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e15954afb1e2f9788668f46238f8318fadd0d7847abdd004e36701b0acd6db3b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c4c5444b2007044e15e023483e12a91e14665d07c80fed157a1eab7467460339"
    sha256 cellar: :any_skip_relocation, monterey:       "777b83fb9d219cff9fa68444da71bc12738cd9d32aaab33b8b1cdb6e723b3abd"
    sha256 cellar: :any_skip_relocation, big_sur:        "caba6f591f3af326a69ffe39ea8cc817d8db285199bf7f0ac83804baf061e680"
    sha256 cellar: :any_skip_relocation, catalina:       "abf9386950641baa18302cb200388d34a1a2ed087706871a5398cf370a476195"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a11c7c83af86efdb53b8bd087cdd66a1f80ce721b94b10bed7ce96aec8467347"
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
