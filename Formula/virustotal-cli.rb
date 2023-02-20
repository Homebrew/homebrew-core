class VirustotalCli < Formula
  desc "Command-line interface for VirusTotal"
  homepage "https://github.com/VirusTotal/vt-cli"
  url "https://github.com/VirusTotal/vt-cli/archive/0.11.0.tar.gz"
  sha256 "947fce5cf2b82e6d7cd53a7b959ac0fded1035fd2c175efae38612c64ba8c032"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5de835e77c607681979cc78ccc0bd83c0c918f73f0b571a3544ea68f375ffb22"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2b78a4c365435409ac89346e9e79ab8ae9fd0d77796e83e7fdd9e4ffd747cac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "54a3bf47b29786b89d4a38520cefdd4a9219885f37e3f1c0b6ceaf1f12715d3c"
    sha256 cellar: :any_skip_relocation, ventura:        "d1c41d61e046e5e84fc7aaf94102efe70bce9f6a09a2818244214a14f9316f9b"
    sha256 cellar: :any_skip_relocation, monterey:       "f8995964f4399d4d098e4d290ff86a51caa4237f986a7ac1f6469b0ebd175abf"
    sha256 cellar: :any_skip_relocation, big_sur:        "b33482824d0ffc3e1ef8700873bc05d1313ca2fb4ec0ac2ded8e26341b35316a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4880ea22ee096d38fb6e21c5feadaa0652ca58de89e65d5a1e3a009a3114b8c8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"vt", ldflags: "-X cmd.Version=#{version}"), "./vt/main.go"

    generate_completions_from_executable(bin/"vt", "completion", base_name: "vt")
  end

  test do
    output = shell_output("#{bin}/vt url #{homepage} 2>&1", 1)
    assert_match "Error: An API key is needed", output
  end
end
