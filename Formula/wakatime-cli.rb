class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.28.3",
    revision: "7c3f8786e7b8ac2ffe5ecb4ec11767295a86578b"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2bc056e2c8bcc042ae18e8c40376da56761d2c58e76607394ed38944516ac83c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "34419dca30bda74e21cf279fadf8e44a1bf8f329ce2a39ec9cb8b0b2a155ab97"
    sha256 cellar: :any_skip_relocation, monterey:       "fa1afbacf5e16534d6a9fbdd0bfdc3ffdac70d4f92bc5402b6e004e2f988af3c"
    sha256 cellar: :any_skip_relocation, big_sur:        "9c4350935aee682a0c11dff4024496f9d4e5d2b17dcacb0e32eef3b9e64be25b"
    sha256 cellar: :any_skip_relocation, catalina:       "040c11d199ba6c2073e65fca3ec716783107ea0b2fc62464f4bc26cd0d114868"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "485d46dff798a8dbccb81b68a94d9c19019c0c26fffe48c43c5b38346517d279"
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
