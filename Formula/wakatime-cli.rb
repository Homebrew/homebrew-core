class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.32.1",
    revision: "f920c619e67122894dd1e6f465afcc78290bf1e3"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f44bcf6f7ac4287a00b6e7f94173d215f59244afaf2916ff7cc936e9634e97f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "909aa0070571ba3a5584ceffa94d5b5f75a70bc0c46699ddade9a2321cde23af"
    sha256 cellar: :any_skip_relocation, monterey:       "d7a8b0c3b24e41824092a9b9afa572d4982668d0909a1256aa93739277dc308f"
    sha256 cellar: :any_skip_relocation, big_sur:        "8df3ca349b587cec514e83dced8e112bf52d7efeb9f2b5a38f6467f9e019e136"
    sha256 cellar: :any_skip_relocation, catalina:       "aeb49d621881506e1c9816a886ceaa4419db183a6cc0d71f79d3320a90d7c90d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e5b9fda5bca946de756660e7331768d053c31d3d2c95cc82c969a7e02b7809e"
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
