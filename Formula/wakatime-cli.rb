class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.27.0",
    revision: "10b3e68df13901dad7c6d03697260c54a921afbf"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0934d62592e6233bb7d0075465cc66f1e537b891eb5540b0816aa5a296035458"
    sha256 cellar: :any_skip_relocation, big_sur:       "2c41b264e05599d74b4a11348bd5a01fa68c4e08478ef08a92194566f9fe6c57"
    sha256 cellar: :any_skip_relocation, catalina:      "485a664d57b70753504c9e968d05edbfe1f45726bb1cef7ae4d8f344a38dd5a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39e0bf6733df53382c4b2f14230e01a6a0f132beb95a1db803e479d7919601c7"
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
