class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.28.3",
    revision: "7c3f8786e7b8ac2ffe5ecb4ec11767295a86578b"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a77311400f1acc823c7e11afa9d2c643b4e88ca406d99950b7102c950b64b5fb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f4c93bfc1a8dfbbeb660d8e19dee9038a19b44f0864cfb2f109ba3196c2ccd60"
    sha256 cellar: :any_skip_relocation, monterey:       "22f9e334f141785864bd0c52ce9b7d8c7e0711fca2e7cdae3d6edbf48f36854d"
    sha256 cellar: :any_skip_relocation, big_sur:        "e351d467e4028feceb1c202185ce932f9a2b5b4a076858b2763a509ddcbab232"
    sha256 cellar: :any_skip_relocation, catalina:       "d3fad7dd12a2b816b74e71445e449a15c4510cf729ce8ce20e204b7484a10352"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4f890266cc3335fd3cdd08d72f9023c157ede9801f9d41a2e240b54bc4d00d8"
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
