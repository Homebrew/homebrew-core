class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v1.131.0",
      revision: "71f75a0bc9521a950fde6d4b10dd378d1491c7be"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b262c6203e69718e5084f97b1a487d320175350fbf4b053c24dc24cc48ee349c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f865313a2b4c3dcb382b18e04d30f6eb8448cfbfd2022243686ae3bd1372adf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f865313a2b4c3dcb382b18e04d30f6eb8448cfbfd2022243686ae3bd1372adf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5f865313a2b4c3dcb382b18e04d30f6eb8448cfbfd2022243686ae3bd1372adf"
    sha256 cellar: :any_skip_relocation, sonoma:        "03e9b73352730afd93bbb1a4d69c83c200a3aa0a018439196a758f285cfd39b4"
    sha256 cellar: :any_skip_relocation, ventura:       "03e9b73352730afd93bbb1a4d69c83c200a3aa0a018439196a758f285cfd39b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de4c75bd897eb100a9e02677542318d0b964df86fd5188a3b0de53f92c666426"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8179095604d08f93c0d46842cd9851afd40bd2f124339b97a2ee0df752b79e30"
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
