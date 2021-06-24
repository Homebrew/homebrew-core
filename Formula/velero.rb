class Velero < Formula
  desc "Disaster recovery for Kubernetes resources and persistent volumes"
  homepage "https://github.com/vmware-tanzu/velero"
  url "https://github.com/vmware-tanzu/velero/archive/v1.6.1.tar.gz"
  sha256 "92f3811d6919325d0e005d52e28e5d31715979851181946e912ecc7bb239e5b8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9ec1edc47dc7cf10e58611986e504028787921953f43a27eddf75dfa28e59f9c"
    sha256 cellar: :any_skip_relocation, big_sur:       "3793747c07f37e2088eab787d3cdbbf9b55c9a804787efa1e8cdf854407234ff"
    sha256 cellar: :any_skip_relocation, catalina:      "605826184cccbb5d34331dd5b410615667a921c9adf5a4ad3499f1140d62bb75"
    sha256 cellar: :any_skip_relocation, mojave:        "3b4b493abdc403991fc85f562a0234924c5fb2e4d9633d7696c9a3a4a11b08e0"
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
