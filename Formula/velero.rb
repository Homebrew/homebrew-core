class Velero < Formula
  desc "Disaster recovery for Kubernetes resources and persistent volumes"
  homepage "https://github.com/vmware-tanzu/velero"
  url "https://github.com/vmware-tanzu/velero/archive/v1.5.2.tar.gz"
  sha256 "a0c872567a5476a4483dc227ede6491e6d15fcf8da2ffd89c3e42a66550dbf91"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "af97699b725bd62647cce8bac841880a7548f336ebd4a07dd197a4a82cadf772" => :big_sur
    sha256 "62b8158cf9b2aa8749e93763f454b7f305b9a6a7a0f7b8f110b635687368e60c" => :arm64_big_sur
    sha256 "5b70ff784f0edba2dda2f699135e604a76cbd67af114f78c23c86c1890bfaf4b" => :catalina
    sha256 "89e30e8c8a90e649177b1914948c1df42bccdacb8197a1e0de563487cc4c0fcb" => :mojave
    sha256 "ab4a5c4b5ee8d4d4f968f8af9a2e86d5ba42109dbefd3d019dc1c4b31520effa" => :high_sierra
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
    output = shell_output("#{bin}/velero 2>&1", 1)
    assert_match "Velero is a tool for managing disaster recovery", output
    assert_match "Version: v#{version}", shell_output("#{bin}/velero version --client-only 2>&1")
    system bin/"velero", "client", "config", "set", "TEST=value"
    assert_match "value", shell_output("#{bin}/velero client config get 2>&1")
  end
end
