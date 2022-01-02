class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.31.0",
    revision: "42de6704c0d56f89a11d43a86cb4b494217002bd"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7054c912511bd5c1f05e08230b46021b1f0f391084a2f921579051ae5a94a24e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9a9c4a460ea35b95a08bbba64da09b3f84dab4d3e30fd2f35a6b7599c96c3b7a"
    sha256 cellar: :any_skip_relocation, monterey:       "3385311404d1da4752d98df02c38b674f3ff13fa812f48cf5ba084249d657722"
    sha256 cellar: :any_skip_relocation, big_sur:        "6cfcc6a0bc229e7f9756616447a28f72dcf5841d35a44197253fa14105b6db2c"
    sha256 cellar: :any_skip_relocation, catalina:       "165b617093d80bd8905908fbad94fcf4670f7a12f3eaa99dcfd7fe8b7945c9b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c09847c5ddbbe117755a2cbe88a98f568a91af05ebb22714de5cae18e34c2dad"
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
