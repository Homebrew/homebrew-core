class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.70.0",
    revision: "cec4fa69acfd9681de0e919cc8fc9f0f03ea183a"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3701a00a966bd12645ee922dded32f88d9421bc0f995c4f410a40f72e49220a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3701a00a966bd12645ee922dded32f88d9421bc0f995c4f410a40f72e49220a2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3701a00a966bd12645ee922dded32f88d9421bc0f995c4f410a40f72e49220a2"
    sha256 cellar: :any_skip_relocation, ventura:        "5b5c1ea5d56175b6003446812c3f0197fec2ac9f566d5784df13e521eec701de"
    sha256 cellar: :any_skip_relocation, monterey:       "5b5c1ea5d56175b6003446812c3f0197fec2ac9f566d5784df13e521eec701de"
    sha256 cellar: :any_skip_relocation, big_sur:        "5b5c1ea5d56175b6003446812c3f0197fec2ac9f566d5784df13e521eec701de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e52f6cd7bddc8833b1361ae8d873abce37c4d5336a287c48c1474fff4e8e49d"
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
