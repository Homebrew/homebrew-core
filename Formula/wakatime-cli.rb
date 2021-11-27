class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.28.6",
    revision: "ef677f46a0c94dbb52ea742a0036a643eddd7da5"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dbf9212461ab586cb601800be13e76155271e34e603d884e3ec8589bf28f72e6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a9e55d1d2449bd070e7b2252b7e145dd9a406e6460537a01eaed28dbb50a1a16"
    sha256 cellar: :any_skip_relocation, monterey:       "1698ecf58e3780e8e6b7204fe6d60f43b2ed8450f01e98599c146b787393eccc"
    sha256 cellar: :any_skip_relocation, big_sur:        "e1dd1e7af1659df3d981f9f73f2724d7009b45c501517b015d5d1535791fee2f"
    sha256 cellar: :any_skip_relocation, catalina:       "c431a8c840c2b89c78bbd457157f598829dad527cf0891d2f8817753edc5261c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73b212c744a038a949c593b9f784607f75174ff0ff06d15602d049e7fed23078"
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
