class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.30.5",
    revision: "482619316453388166717a48415936092fd23236"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "595011c8c01661dac9ff40c8d3df5b3568df27b1baf4b824bcad8c437195a485"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "55e0d5c0844cafdb1bdda55a031035d76506d0e6afe93bedfc73c1632563ed17"
    sha256 cellar: :any_skip_relocation, monterey:       "29b7e4c63a8bbbca78358792644403676f9020f8774c7e00dc17e441194894e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "f36202b908b01b63814e6095d3d6ddd04f3a1e5ad9baf89c2caa785e8347259c"
    sha256 cellar: :any_skip_relocation, catalina:       "e67eff82b0955e12b6fe44baec6c4793553c4720c1f5f796e76d55c4a45f33f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "907b4ddea4fada0c2c9db5ce521df4e51d0a8963dfaf8ec3d7aabe17313f08f9"
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
