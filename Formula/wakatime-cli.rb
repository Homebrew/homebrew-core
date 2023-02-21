class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.68.0",
    revision: "154d2385e7addabfa9eca91c44e8d420ebc3665c"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e822015c0b2b02fc64128e9e968a965396393994f7215b710f941d0a2676358"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d724ad81d2ebea18b90783261f6bddea7bb9b35d50a6127a165ab9e6f209956b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8d01dd65d32628efd2e3763bb1fd6d402b5a0aee16ea0e36e429df7441bc36ef"
    sha256 cellar: :any_skip_relocation, ventura:        "52ee0b6d39fe14fc5873c777af63f713d9556312bbc0616ab5a7a4803cce593e"
    sha256 cellar: :any_skip_relocation, monterey:       "db9cae34dad640b49ae97c5058366f8d8214161ec166ad69eedfb15a2cc2fe77"
    sha256 cellar: :any_skip_relocation, big_sur:        "d10b004aedd5884a36a078b2de4b51c89658112fb2734c27e5a2de3d4598209d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb60f1400d84c0759dbebc32db20ea6643bfad7eeb057300767e927249c3adf8"
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
