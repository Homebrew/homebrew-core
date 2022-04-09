class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.40.0",
    revision: "144cb9962a47ff3a2b24586236cfbf276565a39c"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71192910ca180d7a43f60638eeeef4c3680c907114ea51268b5845281acc160b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6ed2efd92cb54609c8dc4577bad453148e60c939b3f40122a117bef43c0cda5b"
    sha256 cellar: :any_skip_relocation, monterey:       "7e171bea21224bcadd8c7c0d56a28ab9482281458f707c5fcf89debc8281cd7d"
    sha256 cellar: :any_skip_relocation, big_sur:        "5820e2d891087fe3b74ba2fbe0fd5ab57b96d291e67f18f8034e6fb1e12d758b"
    sha256 cellar: :any_skip_relocation, catalina:       "c12cf2ef46cf14b81d1bb39bc4f46bd6c01523f148859ee341d169f522e5b024"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e859de0da860ad8af111305405f0c8504835ccda885e4634fba92e6a84c25d0"
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
