class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.73.0",
    revision: "899eef6cc92626a42c30eac0ab8e356e80982a5b"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa7f7b72daf622e440aa83a3e2ef14ca5ff8f0ef4a1d45ab322e972bdd96ada5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa7f7b72daf622e440aa83a3e2ef14ca5ff8f0ef4a1d45ab322e972bdd96ada5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fa7f7b72daf622e440aa83a3e2ef14ca5ff8f0ef4a1d45ab322e972bdd96ada5"
    sha256 cellar: :any_skip_relocation, ventura:        "b76341bb2dd9227934838d3c43aa11c06c07d74fd4b0c3d988ce349388e6f297"
    sha256 cellar: :any_skip_relocation, monterey:       "b76341bb2dd9227934838d3c43aa11c06c07d74fd4b0c3d988ce349388e6f297"
    sha256 cellar: :any_skip_relocation, big_sur:        "b76341bb2dd9227934838d3c43aa11c06c07d74fd4b0c3d988ce349388e6f297"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "350d5e8b69c926d65baf3a7400f78c04131c12c465ee8b7fc868678e13a00a65"
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
