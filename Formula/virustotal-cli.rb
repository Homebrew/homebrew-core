class VirustotalCli < Formula
  desc "Command-line interface for VirusTotal"
  homepage "https://github.com/VirusTotal/vt-cli"
  url "https://github.com/VirusTotal/vt-cli/archive/0.9.3.tar.gz"
  sha256 "7ae5335bfb764b1f85f049f3771be0621e96329f0af72a35db25a77821e96ab7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bed73543cdd6fbbc1137ae6b576566dedaa66c293a95cb8f4ac1eaafb26c6572"
    sha256 cellar: :any_skip_relocation, big_sur:       "f0ad36afd300d28273eff2e63691a7fc58230f4b97340203e16c907e9170180f"
    sha256 cellar: :any_skip_relocation, catalina:      "0e172bce9fe85e4a308b83f9b61e9ef7cc17a98d0149101ad8c1bcbf04a9dfdd"
    sha256 cellar: :any_skip_relocation, mojave:        "8ecc29c663bc896f5eb1a5a70d4ef609da334d48018966283499a31b8584eb1e"
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
