class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.27.13",
      revision: "3b719c8b911ae8abe4c655108a089fc466d9f186"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "19f940032b85970934fbc58767b8489a9de7330fd4b1842c0193708f84401660"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "19f940032b85970934fbc58767b8489a9de7330fd4b1842c0193708f84401660"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "19f940032b85970934fbc58767b8489a9de7330fd4b1842c0193708f84401660"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "91df44d7774952348807fb46a8f2c0061a4f565945f00819835f67c13408d247"
    sha256 cellar: :any,                 x86_64_linux:      "1c6962aa0c379ae9f173dc632517e547561793f2aa1472b0beded1d5f3855308"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    ldflags = %W[
      -X github.com/wakatime/wakatime-cli/pkg/version.Arch=#{arch}
      -X github.com/wakatime/wakatime-cli/pkg/version.BuildDate=#{time.iso8601}
      -X github.com/wakatime/wakatime-cli/pkg/version.Commit=#{Utils.git_head(length: 7)}
      -X github.com/wakatime/wakatime-cli/pkg/version.OS=#{OS.kernel_name.downcase}
      -X github.com/wakatime/wakatime-cli/pkg/version.Version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"wakatime-cli", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/wakatime-cli --help 2>&1")
    assert_match "Command line interface used by all WakaTime text editor plugins", output
  end
end
