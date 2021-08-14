class Velero < Formula
  desc "Disaster recovery for Kubernetes resources and persistent volumes"
  homepage "https://github.com/vmware-tanzu/velero"
  url "https://github.com/vmware-tanzu/velero/archive/v1.6.3.tar.gz"
  sha256 "06846a5c4e3dd5dd9a44aa6fd2f61674b375ac101bf7e1e1b80b957095258398"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ee599e095bd5dc21c6bd7b4793ccfa2c8b6bf83ca55c0fa1e9c9a2deb08df194"
    sha256 cellar: :any_skip_relocation, big_sur:       "33ff7a1ed0a612ddfe1a982388820da6f7856f6aa8b89f1ecc9fb35fa39c9b4c"
    sha256 cellar: :any_skip_relocation, catalina:      "cc0f1972abd050b5314d43f17fc9f18c668b4b8097f2798a9ebbfe15dab972c4"
    sha256 cellar: :any_skip_relocation, mojave:        "9d28b9ed18c13f120f22b79a65c7e6e22a4513592f80010c554a73419c48fe6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d29f54c12c59ff72861dc8ecc6060c37a760b96653e339aafbfb3a3165df52af"
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
