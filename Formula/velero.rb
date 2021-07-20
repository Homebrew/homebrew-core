class Velero < Formula
  desc "Disaster recovery for Kubernetes resources and persistent volumes"
  homepage "https://github.com/vmware-tanzu/velero"
  url "https://github.com/vmware-tanzu/velero/archive/v1.6.2.tar.gz"
  sha256 "9b619a9a6c80801ec51b01fe1b4bb3b769eba8d4f1c169a4d219acdc2345bad1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ba0c40580772e699248b5f08c5c3f2cf84271f2b8dad0393251568548e6c09bb"
    sha256 cellar: :any_skip_relocation, big_sur:       "902bf56cdfcaf13f33bad13962c3e4198402d9dcb7b35cd3f8c72c50211dceda"
    sha256 cellar: :any_skip_relocation, catalina:      "75e2e3aacc2af7ba6a06700b523469288989cfe3c9364f09577c4a2d8b52990c"
    sha256 cellar: :any_skip_relocation, mojave:        "359defff29b8583dcd8e962ededd22a53fbd9316b9c5e4b49bf1aff6c02b8b32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90dc5e72424cb9059b8feec86ee63f2a3cea9b4ea0045c76f7a87e805e5b58e1"
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
