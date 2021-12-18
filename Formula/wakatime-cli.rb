class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.30.3",
    revision: "87208d0a3537f97c673ed2156352290f562ca176"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f16f9a8887542b6ed1ee8d241cf0fc50af95f470a05e501a60ae1b65d53d72c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "45ad36bf8116384411819dc8588eacbc130fd48f8ce3f22a78a40a4c564a45e9"
    sha256 cellar: :any_skip_relocation, monterey:       "fc97956384969ec705c4b3bf1617efb42c1830a1bdbc40bf10b9b6549f43c384"
    sha256 cellar: :any_skip_relocation, big_sur:        "51f8cf3be4c798e60fc03e5029ce2460fbd7d3641bb9eb2ac8715b5ca4a56751"
    sha256 cellar: :any_skip_relocation, catalina:       "63bebaeb3209b3712fae1b4d4de9ff22fb801daa0e548ddf793d49511f9b73f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2529510d9a37ae619fbb344be671eb77ca3bdcb5ca7c6b95067da1273c53b8c7"
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
