class VirustotalCli < Formula
  desc "Command-line interface for VirusTotal"
  homepage "https://github.com/VirusTotal/vt-cli"
  url "https://github.com/VirusTotal/vt-cli/archive/0.9.5.tar.gz"
  sha256 "97912c4f570fd3e2d5add016be64066ff5e6fb174d0814255f3d7d1dafc36505"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ff3bfa6a99bade68359b1e8fa45a52356cc06ac79a207ed31fd28b2964ca375c"
    sha256 cellar: :any_skip_relocation, big_sur:       "c421dfa169f12c767415d2e1d2a6c0fcfaeb8421144226fc8f2c1625e476fff9"
    sha256 cellar: :any_skip_relocation, catalina:      "d3c0a0b778ca4359a3d47ebd24d01fb582d12a9b1aaba74c9c92d46ae8adf3dd"
    sha256 cellar: :any_skip_relocation, mojave:        "4aac3e1b6ba937c47959ca9d8411cc6df9b3f059005db9abff7c316329dbd503"
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
