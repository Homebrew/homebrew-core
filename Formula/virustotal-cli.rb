class VirustotalCli < Formula
  desc "Command-line interface for VirusTotal"
  homepage "https://github.com/VirusTotal/vt-cli"
  url "https://github.com/VirusTotal/vt-cli/archive/0.9.6.tar.gz"
  sha256 "468ee45eba6234be1bfdfae9421b0b87bce3768d9cb09c777ca6bc1735d5af67"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5fa8318756c65bc80f6a6da53a02725f9c71d83d7ac762ffe0b8f841b28e065d"
    sha256 cellar: :any_skip_relocation, big_sur:       "a2a77c2bb93847075627f29c0647520c0ea1c52f8a42642a38b84fb55ef9c80b"
    sha256 cellar: :any_skip_relocation, catalina:      "503640901267849943d77acc565117035f2ea14724e0e18f5bb6510e6dfc6cc1"
    sha256 cellar: :any_skip_relocation, mojave:        "60a2c00bc879b6b72bf73d560aa765d227e30541f981200ee2018c3a55c238ec"
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
