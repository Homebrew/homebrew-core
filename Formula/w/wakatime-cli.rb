class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.13.0",
      revision: "6af1428ec2aa4f811b68f9afec7a8744a1cfdc56"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb9efe754d700640ff1914bfde7ffc8f7dd15c30f0d2086154ff78cdc6960821"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb9efe754d700640ff1914bfde7ffc8f7dd15c30f0d2086154ff78cdc6960821"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb9efe754d700640ff1914bfde7ffc8f7dd15c30f0d2086154ff78cdc6960821"
    sha256 cellar: :any_skip_relocation, sonoma:        "bbfe97029203cd57e555018e5c428132377fae31c0ac5129a57b7101c81ef51e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25a257654acf616c30b04a0d3841f6c2bb9e25a973635ebfac4d70f1c7c906f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4f1736e66b9159c75ee41dc9098dac8e92c07db99e65bf6f53011d6a081d0c2"
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
