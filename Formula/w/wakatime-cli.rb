class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.88.7",
    revision: "8a45c197f85f520acee531e8d85ef4b0edba439f"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2d48dd47aca34410e02f5346ea9f28c63b6c5eb5a7a7982a4813df1fc735a888"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d67dba13f02c8e48eeef5eb7e419b01e5fd1c4d3d63f69998816131681237809"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27dcdaca1f2e90dabb4d2c468b80d120867d6ba084bcc1ea47b3d3ee93b5b1e2"
    sha256 cellar: :any_skip_relocation, sonoma:         "4ec1e990039da5a82ac4cd0893bcf232a54b385ed3d839e74913a158bd5887d2"
    sha256 cellar: :any_skip_relocation, ventura:        "aed9271624ae60d09afc90140e9582f09674ffbe6c851490dd8bd87de8396b32"
    sha256 cellar: :any_skip_relocation, monterey:       "d80b3385eb7a6a344e4e620d6ad0a5dc32ee8c364373f383c7c4157194300c05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80531a31a53e85f2d185a226cfa59d8d34ac819d2b10110e3bbaeb01b2b24ce4"
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
