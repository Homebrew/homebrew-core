class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v1.118.0",
      revision: "677c1c90bf3b2e052efd447ef2800a5ac3f1246c"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91c80f68ecf2f998eb42f908c2d0a65272f1e27bda9a66d375c1fae2cd41ab3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91c80f68ecf2f998eb42f908c2d0a65272f1e27bda9a66d375c1fae2cd41ab3d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "91c80f68ecf2f998eb42f908c2d0a65272f1e27bda9a66d375c1fae2cd41ab3d"
    sha256 cellar: :any_skip_relocation, sonoma:        "7eed44f3843b50d37c7735aec91d4d01848b933f4af50dda59f5e7490328ff27"
    sha256 cellar: :any_skip_relocation, ventura:       "7eed44f3843b50d37c7735aec91d4d01848b933f4af50dda59f5e7490328ff27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "307aaa63c875168080b61003424a1e7de95aeb49f3139296ff59f080a1df3aa6"
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
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}/wakatime-cli --help 2>&1")
    assert_match "Command line interface used by all WakaTime text editor plugins", output
  end
end
