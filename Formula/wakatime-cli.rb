class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.55.2",
    revision: "9fa449ce0970d46d0b036d799ccab08664cca6ce"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "494072407ec7fceed22debd990181f9b1effa97b526c04772ddd619cb4b423ca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fcae2f4df823fe35dc9b468ebe368ed2f826ab0ccd710f579407dda66214abdc"
    sha256 cellar: :any_skip_relocation, monterey:       "f2451882b4902735112089dd125175a6aa798d744b06961e288e2cc9fde0857c"
    sha256 cellar: :any_skip_relocation, big_sur:        "f65ae39828896b46195ab61254d5c31a503cf2118288ad7f47589319e04ebc19"
    sha256 cellar: :any_skip_relocation, catalina:       "932218438166c147a803be43391edf43e82bd68d68ebb026cec5eaf0a866a201"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4dc98577f16e6e480741200eabad060832f68d7bea45109dcf3dc0855bd5087d"
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
