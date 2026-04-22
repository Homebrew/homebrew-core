class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.7.0",
      revision: "e1d9fdceed532e05231a6b0af17a9ee9de5a6740"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e374a6c4c29122068c67a645767ec6b4951976646d0e4eed1ad0fd2d725f15fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e374a6c4c29122068c67a645767ec6b4951976646d0e4eed1ad0fd2d725f15fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e374a6c4c29122068c67a645767ec6b4951976646d0e4eed1ad0fd2d725f15fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "b72f77f48a1d87bb8670abe139a05c09c331764eaddb05e4e32ee1463a3379b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c4b8ff3d05d7da0964be22f794fda4398cd542be7aa77d3431a2bcbb6721acf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0f308c8553d044c03ec16cf298b94b03325af9c288b03075f76984cc4159a2c"
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
