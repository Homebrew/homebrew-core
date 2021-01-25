class Velero < Formula
  desc "Disaster recovery for Kubernetes resources and persistent volumes"
  homepage "https://github.com/vmware-tanzu/velero"
  url "https://github.com/vmware-tanzu/velero/archive/v1.5.3.tar.gz"
  sha256 "f541416805f792c9f6e5ec2620b0c0f5d43d32ee6714f99fb9fadd8ee9072378"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "48533b571d22497df4c10e6ec43a356e060923ebdeebf79d4294bb06ac4dd222" => :big_sur
    sha256 "e38bd17473efe454d815194e52ca516ce08ca1623e0d0a2f33a7043ac22f51d1" => :arm64_big_sur
    sha256 "e88af008dbe0f1aacd927c9d1d545cb4377b1bbcbdefd8ea7ef60d29eb52fae5" => :catalina
    sha256 "d8c95c53579e629b85ad556d49f01fc9b669e97d5a0d08158af20faaf1fe2702" => :mojave
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
