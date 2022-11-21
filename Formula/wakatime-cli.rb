class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.57.0",
    revision: "98785dcac1d2d1270901cff44388f9c4c2802a29"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8cbe78fe49e02dc48086a5ddb64964dc9c2c2beabcee30ced99ca2b68ba386ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "774dc0540db6dd1a9314e773f1c9df2fbcf7f9cdd05c56306ae34402ec5fd904"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0de507c8318b53f1281ebd2910599d75bb059904efd6f58ba97917c4acff8358"
    sha256 cellar: :any_skip_relocation, ventura:        "8bda479566924fbdd2ce1ee01b770f782b116425b60d0879ff90735944f8b52c"
    sha256 cellar: :any_skip_relocation, monterey:       "91389341b8d761d3ccddd7bfcb08a286a4e9ace86d3a1a58dad2d71d572947dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa31fb6a518988225c3013aac7a99ef81794d41b588816e84b557db6f98230c5"
    sha256 cellar: :any_skip_relocation, catalina:       "58f58aa22391e9a162208644f236e555ea9be95dc8365733d47b2ad12e0f3557"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2476d7f31a1062fb7a4712097afe2239a1de28142bccf508f4091859f53609e"
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
