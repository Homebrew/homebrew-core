class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.24.4",
      revision: "3675b05025a571637358fc1cac3f29cc94284459"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2def22a60342cbbaa1f3c56eb21d8b79f9f9af21224438332a40e3550ef6e194"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2def22a60342cbbaa1f3c56eb21d8b79f9f9af21224438332a40e3550ef6e194"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2def22a60342cbbaa1f3c56eb21d8b79f9f9af21224438332a40e3550ef6e194"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c72c5d473ff926f4bd96ead48f72f8c14b535abaa014600d603e3938ec6378d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1fc1b72927ac6c5fd5f23bbde67ca028ef10f4cf42b66eacd1eef78d812dd5f8"
    sha256 cellar: :any,                 x86_64_linux:  "f729475a1a73a0508ba734d4458aee00b42c3450beeb4f81bd3faf72260654b2"
  end

  depends_on "go" => :build

  def install
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    ldflags = %W[
      -X github.com/wakatime/wakatime-cli/pkg/version.Arch=#{arch}
      -X github.com/wakatime/wakatime-cli/pkg/version.BuildDate=#{time.iso8601}
      -X github.com/wakatime/wakatime-cli/pkg/version.Commit=#{Utils.git_head(length: 7)}
      -X github.com/wakatime/wakatime-cli/pkg/version.OS=#{OS.kernel_name.downcase}
      -X github.com/wakatime/wakatime-cli/pkg/version.Version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"wakatime-cli", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/wakatime-cli --help 2>&1")
    assert_match "Command line interface used by all WakaTime text editor plugins", output
  end
end
