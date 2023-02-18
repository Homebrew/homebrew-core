class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.66.0",
    revision: "e59ee9b0f93d0aa089e3d5af24daeeec09ea85f6"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34705e07be0723a0d3c4ee1e2c9a8db02b42ff7609ea779262855dcee9b8193f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53539794b98d480349cdaa8d0829bf463c8f1ddb1391919c4ff5f15e51076424"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d76559dec8a49253ed7addd93ecce7ee2ce8e34e27ddc7142225cc4839732b24"
    sha256 cellar: :any_skip_relocation, ventura:        "0891d9b319b6a2b5a64e7ee427bac5c5c4263b6572a9b2be93ce27756dfe83c5"
    sha256 cellar: :any_skip_relocation, monterey:       "3b193b78ed602afdfedfe450d24a60ffe373e4961d7c979d36341f489c08d180"
    sha256 cellar: :any_skip_relocation, big_sur:        "c4530ca897fb9210f87287fa0a6a640092fa6e15d0b3b25f10fe34ce17a5856c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf8a5f33203c22202fa07ac73eefd2e691af74c16cca00d9b6f3627a70814792"
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
