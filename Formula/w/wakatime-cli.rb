class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.21.2",
      revision: "600632ae9f20a5fcc4543951bae053df66956da5"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f1444cebcadf44a1ccd681a3fbefdfac2fd399f563de169eef841bd394b771a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f1444cebcadf44a1ccd681a3fbefdfac2fd399f563de169eef841bd394b771a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f1444cebcadf44a1ccd681a3fbefdfac2fd399f563de169eef841bd394b771a"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c24a2e6f18402b3c3544ff394e66a84668f668e85e381d3db6438ff1615962f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ae9323e0c40e250558c5ff53eed7316c2f1f7815bba707fe07b8d7919265a28"
    sha256 cellar: :any,                 x86_64_linux:  "6bd1e65a7de1c5d06b9265b3a262d34561d7f12b56de64ac82111ea6d483f32e"
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
    generate_completions_from_executable(bin/"wakatime-cli", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/wakatime-cli --help 2>&1")
    assert_match "Command line interface used by all WakaTime text editor plugins", output
  end
end
