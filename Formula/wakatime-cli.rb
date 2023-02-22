class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.68.1",
    revision: "0369af52cb8a5e806ef14fc7f3d08f54ef41e279"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c6286098f8ef615522b822f8644ad744eae502110b75a9b009a9d15aad3b612e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72d3caab6193553b5ee41f4c196519915fdd8cca7cbe2b33da17fe7691c0a84b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c82f84f94168807d83e5d063520989da5fb065f86c53730679f2c91435110d77"
    sha256 cellar: :any_skip_relocation, ventura:        "dba595e2538de688caa3a6f138008ef0a26d56854739656457d7bc5df8325d85"
    sha256 cellar: :any_skip_relocation, monterey:       "e3cb5e350e18fef0b0a17ba0a2894c87c1964532f02bc6f611675da9e22a8a4c"
    sha256 cellar: :any_skip_relocation, big_sur:        "ac5fbeb9900f682f112ec537c60c15a89f278b67e33179cb7e31a805d68dd3ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "484081cebd3d3fb39a643f388fd5bb6a0e842c19e2f73d53b31393f1db36b6df"
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
