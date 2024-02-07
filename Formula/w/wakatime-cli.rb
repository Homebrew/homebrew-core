class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.90.0",
    revision: "cf90685bb615991d118f88cfe96b1306dae0557a"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a67a8189992a84516a7ee504562b3b5d623149c4bdb2a61e09b3dcda2898091b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7633df155c5fea05d600fb1fa5fcd365abe6c0381f36636ef6b9f5798707986f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8de3d3cf79b1820f2647796d28221efb7cd3b6809c388f02d7be3feeefa66d2"
    sha256 cellar: :any_skip_relocation, sonoma:         "b85a3899fe0ef58915b4c5e9d4c85191a6bf2f6f6c0e3b86fda83d37631ebcab"
    sha256 cellar: :any_skip_relocation, ventura:        "d701a0ee9c9c05f2c720211783a88fd23def2ef5f37004482779a0236ea57453"
    sha256 cellar: :any_skip_relocation, monterey:       "1df1b30fbcb4179d0ca7dc8f3d0e50da72a66ca27c12169bc4908219f8f471cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16f13a48e943cd88db857a86ee87de1933de89b52ec5c579926d00a1017cc315"
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
