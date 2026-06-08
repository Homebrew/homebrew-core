class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.15.0",
      revision: "8bd115080cf2e765e119f59730badb591836eae8"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6da7836dfd57b27d105645be491d7acb3f757bd3692d2e7a05be79c5f960082b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6da7836dfd57b27d105645be491d7acb3f757bd3692d2e7a05be79c5f960082b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6da7836dfd57b27d105645be491d7acb3f757bd3692d2e7a05be79c5f960082b"
    sha256 cellar: :any_skip_relocation, sonoma:        "76547af69b0f001f99800e4bf83d4e25084d6567f7703f3896a6e70eb0d40cc5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "938c63775b7eac8490bb481b9d1a6ae5945a013394e5428ab7fa81a15a4ab352"
    sha256 cellar: :any,                 x86_64_linux:  "37d4a3e9499d6fde46b46d32df537d2774ae53a71fccef112c642caf0f9959fa"
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
