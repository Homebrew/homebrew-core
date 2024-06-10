class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.91.1",
    revision: "1495e44d5ce193f1e416449ceefde3a43a837ca0"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a05e479b706c8df0f8df7a2b3f76295686a574a5bef689c9e81440a760436e57"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "486e8df689c7deb0352af5ffd88f3d96c94488033eaced34cfbdbb15c2b22bf7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "383e03c054de9009c74473d7b47bcf398e95edb8999db236426ca9328ef6779a"
    sha256 cellar: :any_skip_relocation, sonoma:         "e7d921a729fd19ef0697719c0b75457397c307ee837a579484322ee0e956fdf7"
    sha256 cellar: :any_skip_relocation, ventura:        "36601d3e2af683adabb33fcf733a7f59222f9f38f3387b0cad4119d2896f161f"
    sha256 cellar: :any_skip_relocation, monterey:       "cb91d916ad7826c7039d8b6e84534d39742d183ab29dd7a22ea0705767382c14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6fff77930418d8f5183112a9942c33af7f56c0333d993a72e2a46e451a4fb840"
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
