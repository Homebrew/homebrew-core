class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.75.1",
    revision: "5bb04b944cb275d312d609dc423347acd2885d04"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b8839e28a0e9ba6cd8df7f91c29d1796a21df875ee32b93cad9d7bd7aeb2aae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5c683b34646c0cef22eea28c591876277501da44353facb844beee6444fa2e8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a6fea38359a78d80b9ec6ace40ee6c0eb32837c72e1ac8036c1f290e5568775b"
    sha256 cellar: :any_skip_relocation, ventura:        "427fd0297433cbe6a2790a1423497e3f23053446eb47cfca814bb960c9fb61bd"
    sha256 cellar: :any_skip_relocation, monterey:       "eb89c34c01788b0465f74d607bdfc196442ee0f3011ce6370a08dcde48b31be5"
    sha256 cellar: :any_skip_relocation, big_sur:        "df5aac0ff2f5ca785925d7729377cdd7b5a56d931552da7bc4d0c92ced0e7c84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52d9cf16fa04c11ec94a36d78a2c6bc5a8ceb26746a8584fc7b33283c16e7bce"
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
