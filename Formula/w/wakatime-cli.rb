class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.86.4",
    revision: "6c9f8912b2211562e066b941067f2280d828e8c4"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "333a4470cd3d98869e4d539f8a3524672de1e55b951b4884fcf9f17779a8e388"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79dccbdcf6758cbb11307d04ec757bb88b34aa117927f0f96ee86bf46486151a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "487a6d15e32d51e7c239fbb2d307086fed858fa53cb3da65794f9196efdd0f74"
    sha256 cellar: :any_skip_relocation, sonoma:         "4148fed128a755769dd87597205dfb3a10e4668ada7e507b34654be0d1485726"
    sha256 cellar: :any_skip_relocation, ventura:        "2c68b20352f9128f7b136204e03f6bac9dac2febca7c20a1d9e4e226807cbfd8"
    sha256 cellar: :any_skip_relocation, monterey:       "8ca0d838b90b1159a235e1a99effcc8f34291ed780e402ffff4940819a60ab4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fece5213ffcb6524cea0be05ccbf973a6b2b478a14da0b49f956e37aff48b6bd"
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
