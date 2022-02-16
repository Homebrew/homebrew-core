class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.37.0",
    revision: "93c42c1e8a89ed2e95157edc475f2c6051e1e064"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a55867bf9c038b16383794089ae6e0548f1d13fb4cd0a5cbc62287f6685af7b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e7dec92343b38d1dd826e2a813385ef569fadfa77445c3842182e7b793182f88"
    sha256 cellar: :any_skip_relocation, monterey:       "e0812cedfec4b9cbc609614eba541bb93dd3ee007317f534d5b6443b93f3cd7d"
    sha256 cellar: :any_skip_relocation, big_sur:        "16fd7dd289d3078ab6d02aada8070781b45c6e9f8bb2b4ba8e3c4e1fd5f9892e"
    sha256 cellar: :any_skip_relocation, catalina:       "550d137f692fb7fad7e1be54c7cdee19e15363215665414ccb6f737f49b7831c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a0782cf408699d26b25235e29e895271be4dbcadd2ed2fed397c8ca4c3b9987"
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
