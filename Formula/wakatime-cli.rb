class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.73.1",
    revision: "c90f2ee34f691a69cf2aaca1e2aded8443617558"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "282af32087df2b97e037a6700a32a0ccf9d991207026208c5cfcc80e1d0dc54a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "282af32087df2b97e037a6700a32a0ccf9d991207026208c5cfcc80e1d0dc54a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "282af32087df2b97e037a6700a32a0ccf9d991207026208c5cfcc80e1d0dc54a"
    sha256 cellar: :any_skip_relocation, ventura:        "73918ca59565db7b4ea421b85f0dbe5512d5b76acb414adc7019e730d5c98272"
    sha256 cellar: :any_skip_relocation, monterey:       "73918ca59565db7b4ea421b85f0dbe5512d5b76acb414adc7019e730d5c98272"
    sha256 cellar: :any_skip_relocation, big_sur:        "73918ca59565db7b4ea421b85f0dbe5512d5b76acb414adc7019e730d5c98272"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "445126f8764c0edf2ce8db81159b6daa7f0f37f0691d56bb5e65487d756b4128"
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
