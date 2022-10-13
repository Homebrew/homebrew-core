class VirustotalCli < Formula
  desc "Command-line interface for VirusTotal"
  homepage "https://github.com/VirusTotal/vt-cli"
  url "https://github.com/VirusTotal/vt-cli/archive/0.10.4.tar.gz"
  sha256 "2960a1cdf4c60d80203b8c339d59c5029537f3bf06b373d477edd7f2288fce42"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "21f21d0b3fd73f5a384df8e530d45b58f1d2c989cf254adbed032fe357185329"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "94d27f2cbf280c5457de6f164801835501e75fbbdcabbde41cc75348978726b9"
    sha256 cellar: :any_skip_relocation, monterey:       "01adf5678748ffd98a796e4a27a102060e4898d73e3cf2764c7b3d375347498e"
    sha256 cellar: :any_skip_relocation, big_sur:        "9a7efc1829ab333fc5679169f4fb0c043f0763c696a2dfae2820b163f388b1d0"
    sha256 cellar: :any_skip_relocation, catalina:       "a18e7ef2399a3b8f38a7ab242bc5a5323e6adab2f97254557766f4f8e245f96d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c89d82d495056117ab909ce0365d5229236694c4bffdcc52784be1905bdbe10"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"vt", ldflags: "-X cmd.Version=#{version}"), "./vt/main.go"

    generate_completions_from_executable(bin/"vt", "completion", base_name: "vt", shells: [:bash, :zsh])
  end

  test do
    output = shell_output("#{bin}/vt url #{homepage} 2>&1", 1)
    assert_match "Error: An API key is needed", output
  end
end
