class VirustotalCli < Formula
  desc "Command-line interface for VirusTotal"
  homepage "https://github.com/VirusTotal/vt-cli"
  url "https://github.com/VirusTotal/vt-cli/archive/0.9.2.tar.gz"
  sha256 "9cddab692b07c53492f83fc5cd931a42cae9d52f602afb4cd327e43d507012c8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "01ab1d441d714db7c88e27a14c307da1792e8532f62cb9a833e0a4a04f801b68"
    sha256 cellar: :any_skip_relocation, big_sur:       "f7c8c0eed54478ed2ee665555ca6ecfb45cc5e0d73f77979bd7bbe8f9b500c1e"
    sha256 cellar: :any_skip_relocation, catalina:      "e13b03fc56454a35f0d04c1d08ac6badd4cc8abc1fff784814c9736d9d1797df"
    sha256 cellar: :any_skip_relocation, mojave:        "cbc3647e7b4a01ad78549dae1c3c9c2f22d18fb77a2a4015d72d5a319521e1a9"
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
