class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.53.3",
    revision: "8ec65d603bc0770363d89c7962b6a7515c7dd239"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53c48f849f49f8d9f9f703e2e6949a671ceb8255f6f081e3bd89ee66bdb48cda"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1533c01120e309010927d137c46134f92ff4812f24593221cc71eb665effa8ba"
    sha256 cellar: :any_skip_relocation, monterey:       "b1d9b957efb277ff96685e65a365722bdf85005792d7033f67d434cc43778806"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab0314b4290578b5375ef64b076b38805b02173aba0b8613a04886e4259a69d7"
    sha256 cellar: :any_skip_relocation, catalina:       "5160690fbfb28b449b563d2b777020178de05b3b2ad5fadb5d164d1506172ecd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6bc89d616079b4256d06c27b760d7a63afdeb8e3ab7d95067bb6ae6a70362cc1"
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
