class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.55.1",
    revision: "b064b306cbd3b28d2f772c30ffa2654bb56ae84e"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3aa7e5eebb7944346a487d8f39c6650fa29af901e56e6d035bbefdb0ab8da35"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3f3eaecad75bc0fce3d751154f6b6f788aa00b0c702827a08881cf328b99757e"
    sha256 cellar: :any_skip_relocation, monterey:       "7d05ea2abb0bc6b50f5c0ddc3b0e1eaca062f96ad50c89995f8bb7dda53b4d0a"
    sha256 cellar: :any_skip_relocation, big_sur:        "88f184e09010f1d86332c551de9e9b75ac7ded26487549c80bb6b4d1217f52d1"
    sha256 cellar: :any_skip_relocation, catalina:       "f71dd35a6fc2a4ed0bce3da26ac80a1c331172fc820633f2df3fdc1a8fbe2f4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57988a4555fb38b8ea3dd7f75e100e92c8cd1d832cc82fe00a702bc15648eb6c"
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
