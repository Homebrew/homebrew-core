class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.76.0",
    revision: "84fe7af3d27328e6f7d86b87b06d56d2c897d226"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db0bab6d28d16832903de79207278b57cf83d718a1a1217471425bf532f8d67d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1343276db9688a4db44bf45f20cb1630fc1ecec28ff19f9190aec27394562420"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ab018e0fd131a334644a3f4e57e8d1b00f615d1c364494c4db5d90b832d1ae58"
    sha256 cellar: :any_skip_relocation, ventura:        "5713456147b5ef58ab84e554e72bf44ac2f9fc7fff99a42d183d555d8bff4823"
    sha256 cellar: :any_skip_relocation, monterey:       "ddf7b27ff1261242574fe46ac79a2df61a64245499934823c65b10362588f1d9"
    sha256 cellar: :any_skip_relocation, big_sur:        "3a9b5828c283c4a737bda50d6ebe8e00736c0c85737773c3512d4db1b9a816e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d4f203216f77d48a2b6a69659764baac32efdbcac3b26c819a293e05fbc3e6e"
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
