class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.45.3",
    revision: "f8796c22a6c14056c71eb41d6a22fe9eac2cb2d8"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78ceb9e3172cc256295ca1395ed5ca839260b8c19f419e560002256d2c403097"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e4609df1103a67b2516d86ad5e29d58829d22f8aaed4587fd850187e87745ae1"
    sha256 cellar: :any_skip_relocation, monterey:       "b99b0cbb7ffc6d2b83412e043dcc6d6ca7fd1de9b37a20e72fb94ad0447da8c5"
    sha256 cellar: :any_skip_relocation, big_sur:        "49cf5578fe0be228c6b96664410ae4f34d113f75032242575eab1a640c0125c4"
    sha256 cellar: :any_skip_relocation, catalina:       "93df70b01face07acfbbc1a749a9b8cb2d3796ec4fc48421898a654e2ca19702"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7230bd98fa1d311f70194b9c4ae452fe8cc747b97028d73d368d230d42acd2df"
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
