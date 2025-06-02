class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v1.115.3",
      revision: "0d0dad60ca98ce9e9aa5aff4afeeb389d2b1a9ab"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b3c04175a831da198087d7d24d61f57c7dbef4e7768edaa44ad351d0bae2f5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b3c04175a831da198087d7d24d61f57c7dbef4e7768edaa44ad351d0bae2f5b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8b3c04175a831da198087d7d24d61f57c7dbef4e7768edaa44ad351d0bae2f5b"
    sha256 cellar: :any_skip_relocation, sonoma:        "4811407c291065b4bbdac0a077447f1f6e1b3fe58352ae224234dd1ac496f3fa"
    sha256 cellar: :any_skip_relocation, ventura:       "4811407c291065b4bbdac0a077447f1f6e1b3fe58352ae224234dd1ac496f3fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85a03419a74b0c3daf71f21ec10ab7caff2160461d88a4d942ef711a3672def1"
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
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}/wakatime-cli --help 2>&1")
    assert_match "Command line interface used by all WakaTime text editor plugins", output
  end
end
