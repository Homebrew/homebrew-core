class Velero < Formula
  desc "Disaster recovery for Kubernetes resources and persistent volumes"
  homepage "https://github.com/vmware-tanzu/velero"
  url "https://github.com/vmware-tanzu/velero/archive/v1.5.3.tar.gz"
  sha256 "f541416805f792c9f6e5ec2620b0c0f5d43d32ee6714f99fb9fadd8ee9072378"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "61756607143eb05f3950ac6ecb173d2668a37a46bf7992a0651f87f3d83aad9f" => :big_sur
    sha256 "25ee370d43bd1ba1cc562a2867b3389be00d78b846f4ddf1f21bdb7b3fbeff9a" => :arm64_big_sur
    sha256 "fe7663190bc36d9c5b3ea4263625cea0024aee9e8f6769c71fa4ffb0272d0fe7" => :catalina
    sha256 "980989cb3a3ed36f4330a71822fb51efa4f6c966b09c27a01f5de7ec77e9a903" => :mojave
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
