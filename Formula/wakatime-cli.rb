class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.61.1",
    revision: "f35a74fd08a03328c7d10fe66adab450a83e8b3d"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "625e4ec993bd69980b655a708ae6c37cf981465a2f7c19c44862070f7fd51543"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "581f1f612514cc92f63792de937c9e8549594b512e951f0762e8f5894a776187"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d566416d9a437631528f61e3a5f3a72f26b4a077dfd7bc1673802f4a137d592e"
    sha256 cellar: :any_skip_relocation, ventura:        "c19d1cece1260026a85941888a80b2a44d75e29f4f7f00f5f4cf663e178b4d53"
    sha256 cellar: :any_skip_relocation, monterey:       "465a7599f268f1f544e144ebf2bcba8cc3be1a23ead89b0694abb61faffd20c4"
    sha256 cellar: :any_skip_relocation, big_sur:        "c25db3634e4a3e941c366e44faea93374607707e3fae5c50abc04dfff0dd8bb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d1acd79ab57c29bd6dca288e22f32a29cf906db0c8529428a0790c17936c23e"
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
