class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v1.115.2",
      revision: "58d267621ce91a5d0e31917fcccec5ea4e3ca07b"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2bc3cf34de1acd8b5f9bacbebb4717211b6b7d582276b5b70b3c0461530504b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2bc3cf34de1acd8b5f9bacbebb4717211b6b7d582276b5b70b3c0461530504b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2bc3cf34de1acd8b5f9bacbebb4717211b6b7d582276b5b70b3c0461530504b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6d247a59e0637d7e9b19c7c4a45e6be18160fde0a70b9481592faaa44ca824e"
    sha256 cellar: :any_skip_relocation, ventura:       "a6d247a59e0637d7e9b19c7c4a45e6be18160fde0a70b9481592faaa44ca824e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ef66eb94a84724a9d2cca6953bbc4728a2ad84cb6050644f89783bfe5308ea7"
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
