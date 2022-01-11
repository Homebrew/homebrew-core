class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.35.0",
    revision: "15895a5d2229a0e72906fa897cab5bd6314a3d96"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5e54f6c2d127083b12cd7ac3b0141cf8f670379b2f45b7977fe70c0e4dcf10d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3f0f639520fa316cb1717a3ea018a12559ca6bee084a2ea5201580581c2e6498"
    sha256 cellar: :any_skip_relocation, monterey:       "ff9111d43b4cab4f482c169007e896d6ff6756c741331d9f0f396899816a746f"
    sha256 cellar: :any_skip_relocation, big_sur:        "928a050e5717d2667e11989f21e3afa62a4de1bcd75c6aa8ba82fa08dc0f45e5"
    sha256 cellar: :any_skip_relocation, catalina:       "6d42760681a1ab2b70fa066079327f9f135866caabdb970a0496cbcfe28f0b78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7452eeeaf99fc2c30861febdc9318e15a26fff77112445df8de8955d48916105"
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
