class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.98.3",
    revision: "f19650c15f52d83ca64af86c007ffcdd505fe952"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0a708554d23a328d8f73d2bec2f5cfc9cf4914224f60710a375284bff0ff11c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2da1964075dcab7f43f6f5df2780d46d8b63783818fc3c37de6e397db87f2f45"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6086ff37d91ee9f89fb9fc950ae6c8544876825b1c8e85f74ef26615b926bfde"
    sha256 cellar: :any_skip_relocation, sonoma:         "df5fd0f77eb0c410ba6ea0a48e22e8e72f2c9f4b59512b3fcfa8844b2764e0e7"
    sha256 cellar: :any_skip_relocation, ventura:        "8b0dfaed87a411be04f397491f8996d54a5e3b980f43b09930f4cac0d61b254a"
    sha256 cellar: :any_skip_relocation, monterey:       "aef2db6794c620a8b4301a5d428de35992d9931d5d7bdae19c634624bc41b048"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b2c42a06f0102f630ce3ad362bece7cfdfa19ff244511cec286b8adcf62a917"
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
