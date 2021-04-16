class VirustotalCli < Formula
  desc "Command-line interface for VirusTotal"
  homepage "https://github.com/VirusTotal/vt-cli"
  url "https://github.com/VirusTotal/vt-cli/archive/0.9.3.tar.gz"
  sha256 "7ae5335bfb764b1f85f049f3771be0621e96329f0af72a35db25a77821e96ab7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "eaa827cc780221725ab0a784772f714f5efba9d346f8249167883fa38991f621"
    sha256 cellar: :any_skip_relocation, big_sur:       "7325dd9a2f1b744bce567fd46e5d0fe345dc0349a8c2c9006a2c3c64119536e2"
    sha256 cellar: :any_skip_relocation, catalina:      "0b50fa33daf59c8f160dd6b48cd3c742c1037c7874ca1307a6ab7e0dfb1a33b8"
    sha256 cellar: :any_skip_relocation, mojave:        "b7488fbcf0d95e3cc3ead35947fab271bb5f6408d5622ecad7ea79834cb29c9a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
            "-X cmd.Version=#{version}",
            "-o", bin/"vt", "./vt/main.go"

    output = Utils.safe_popen_read("#{bin}/vt", "completion", "bash")
    (bash_completion/"vt").write output

    output = Utils.safe_popen_read("#{bin}/vt", "completion", "zsh")
    (zsh_completion/"_vt").write output
  end

  test do
    output = shell_output("#{bin}/vt url #{homepage} 2>&1", 1)
    assert_match "Error: An API key is needed", output
  end
end
