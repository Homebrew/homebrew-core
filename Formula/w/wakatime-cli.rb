class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.22.2",
      revision: "1c5099f30daa6d87cbca3158051579fb9713c56a"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7cf67332cfa6802ca0b04b88cdf3d0ec288abdcc00b40dac65f0fc8745543290"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7cf67332cfa6802ca0b04b88cdf3d0ec288abdcc00b40dac65f0fc8745543290"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7cf67332cfa6802ca0b04b88cdf3d0ec288abdcc00b40dac65f0fc8745543290"
    sha256 cellar: :any_skip_relocation, sonoma:        "51766c0fcd7b6da8d5ea142bd45e22b034be629f0ca9979bce61d50ee1b52721"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d8979521ff49253088502b4a4d6e7d7455920d578bca733cb40fc26f9714953"
    sha256 cellar: :any,                 x86_64_linux:  "3f9c1b39792427eb30716cbabdf4d5503fd2a9f16df51fd27f687b091c427d0b"
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
    generate_completions_from_executable(bin/"wakatime-cli", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/wakatime-cli --help 2>&1")
    assert_match "Command line interface used by all WakaTime text editor plugins", output
  end
end
