class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.102.1",
    revision: "0c905e87f84a98a49eee41a19651a9ef7af672ff"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0e9b2ff7bb36ac9d950e2e626fa62adb2a48f80a1e3439b1f9c0a4c3c6eeef5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0e9b2ff7bb36ac9d950e2e626fa62adb2a48f80a1e3439b1f9c0a4c3c6eeef5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f0e9b2ff7bb36ac9d950e2e626fa62adb2a48f80a1e3439b1f9c0a4c3c6eeef5"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b9b4283e9ace0ffefddcc038c665cbd111c1559905ad5f8a190c4e3cd03e12a"
    sha256 cellar: :any_skip_relocation, ventura:       "8b9b4283e9ace0ffefddcc038c665cbd111c1559905ad5f8a190c4e3cd03e12a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea99501f0c717e1baf743b1bfc62f90ffeaa592ccfddf790f973fdcc813bc93f"
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
