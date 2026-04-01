class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.0.13",
      revision: "97f39ce5f5d8e0a43a337124da7a3a92402c2076"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "93073ba9dd6c3df335f256e2f0f920eaa5d8c10c742ca44e5669fe081eb5010b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93073ba9dd6c3df335f256e2f0f920eaa5d8c10c742ca44e5669fe081eb5010b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93073ba9dd6c3df335f256e2f0f920eaa5d8c10c742ca44e5669fe081eb5010b"
    sha256 cellar: :any_skip_relocation, sonoma:        "d820a6701b62a29134a2a45d6480398e7ebfa4f7176c70458c22729d3185a218"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "68f99e86a27b46a152a4955cdd83c4fef93cd1c702a3e298c2bc0db14d999381"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c45b0ca46278e755eaee6984b5de75b87b0aa2cd78f63fdb10d0686a5eda38b1"
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
