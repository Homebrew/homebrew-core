class Velero < Formula
  desc "Disaster recovery for Kubernetes resources and persistent volumes"
  homepage "https://github.com/vmware-tanzu/velero"
  url "https://github.com/vmware-tanzu/velero/archive/v1.6.0.tar.gz"
  sha256 "68d8bf3c117b3ddfe7e8005238824e802ede83ce76dd670723663a392f779fc9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d04cf9ea27c5d22b4b0a3c58fcdd5402875ed170f0c02be02fd7ba55cae2f66a"
    sha256 cellar: :any_skip_relocation, big_sur:       "584b98c46c1e6b3bfbf2a94e96f2fc207b8cc972da055bc7edc1f0b633627968"
    sha256 cellar: :any_skip_relocation, catalina:      "e63e4913effdf88cc9159d043179db47cfd5599ce714c98e4571abbd57a61564"
    sha256 cellar: :any_skip_relocation, mojave:        "622d2e462a17ddac1d064a16bc7f46c0c05cb5ae45be98ba025bc2067deb83fe"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-installsuffix", "static",
                  "-ldflags",
                  "-s -w -X github.com/vmware-tanzu/velero/pkg/buildinfo.Version=v#{version}",
                  "./cmd/velero"

    # Install bash completion
    output = Utils.safe_popen_read("#{bin}/velero", "completion", "bash")
    (bash_completion/"velero").write output

    # Install zsh completion
    output = Utils.safe_popen_read("#{bin}/velero", "completion", "zsh")
    (zsh_completion/"_velero").write output
  end

  test do
    output = shell_output("#{bin}/velero 2>&1")
    assert_match "Velero is a tool for managing disaster recovery", output
    assert_match "Version: v#{version}", shell_output("#{bin}/velero version --client-only 2>&1")
    system bin/"velero", "client", "config", "set", "TEST=value"
    assert_match "value", shell_output("#{bin}/velero client config get 2>&1")
  end
end
