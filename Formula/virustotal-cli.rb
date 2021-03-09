class VirustotalCli < Formula
  desc "Command-line interface for VirusTotal"
  homepage "https://github.com/VirusTotal/vt-cli"
  url "https://github.com/VirusTotal/vt-cli/archive/0.9.0.tar.gz"
  sha256 "ec418c60697d03fd859bbf3a36abe4f30d59111651e3065de6cd581040a19027"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b486134db1e1ac2fd514acda293401f9d030438dc2f9147ed75339f769ebf506"
    sha256 cellar: :any_skip_relocation, big_sur:       "8b5f87a46607d5b5e8c668e1be2bfbe0fbdb9abbf2fb8e13e600d48581792f48"
    sha256 cellar: :any_skip_relocation, catalina:      "fd824d9358daebc505953828fa412e7833552862619a33bd5d859bac106c037d"
    sha256 cellar: :any_skip_relocation, mojave:        "e3b47ef62dfbb66079fea6d2b49b5cc9a07ec180cf459393c57b6377b8068a34"
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
