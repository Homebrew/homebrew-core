class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.62.1",
    revision: "0704f0d8ed26c2072d45759945ae421786ff2358"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "454ad2a0e57ced6995f6bc58675d69aeaec844f11d13e97cbb4755531aad50b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1bbd9ff187887f28578c739eeac38a6948a31940fc5f384c8bd54d642b94d596"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "140b3a33be3a8fbaafc47b91ccd17aa4667ed21285b8aac9091e12ea7792078c"
    sha256 cellar: :any_skip_relocation, ventura:        "db416369c5d2a15bb83717539870318cc5af7cb02feb40b5898b3bc47cea7bfe"
    sha256 cellar: :any_skip_relocation, monterey:       "faf90776aaa19e66fe1851dfdc6c1794704227a7847ac6732a706d519dc8bb87"
    sha256 cellar: :any_skip_relocation, big_sur:        "2b56e1522406bc7d1f2a91e216b460c452e935e746c6da80026711fa7557fd07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "517b0e86c8ac7c9ecc05958d42814d9af8ebc64651f795f3fe307de6b8529bbc"
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
