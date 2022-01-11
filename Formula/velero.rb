class Velero < Formula
  desc "Disaster recovery for Kubernetes resources and persistent volumes"
  homepage "https://github.com/vmware-tanzu/velero"
  url "https://github.com/vmware-tanzu/velero/archive/v1.7.1.tar.gz"
  sha256 "f008ea2ed6b5f03419399289768db907ec993f4c6ef6947689737d67d4a895b8"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e96eeec41a5dcac7d04a063999c61bbf30d55a4c9fce57b6f4fcd8197e64c39b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e1380bb4d04eae84d4a9cb5210e98ce16d99a2f18b8dc8dd3e6d6bd54d7e2ae3"
    sha256 cellar: :any_skip_relocation, monterey:       "e9bef0f0f023267baa52886357ac482b4cbc85ccbc9c9405e50fed0e9f39184b"
    sha256 cellar: :any_skip_relocation, big_sur:        "cbb0fe2a50ede42fd99ab6dc70a0137ca843d4bec77cbf80e3295428bf755453"
    sha256 cellar: :any_skip_relocation, catalina:       "9f6402b61b970c220eb4178d14739ee1b5dbad44eab79907797209d95449b351"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bc3ebeaed2018400b6f1633b64a2219f43c222fb26b835076f1acce89cdf36e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/vmware-tanzu/velero/pkg/buildinfo.Version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "-installsuffix", "static", "./cmd/velero"

    # Install bash completion
    output = Utils.safe_popen_read(bin/"velero", "completion", "bash")
    (bash_completion/"velero").write output

    # Install zsh completion
    output = Utils.safe_popen_read(bin/"velero", "completion", "zsh")
    (zsh_completion/"_velero").write output

    # Install fish completion
    output = Utils.safe_popen_read(bin/"velero", "completion", "fish")
    (fish_completion/"velero.fish").write output
  end

  test do
    output = shell_output("#{bin}/velero 2>&1")
    assert_match "Velero is a tool for managing disaster recovery", output
    assert_match "Version: v#{version}", shell_output("#{bin}/velero version --client-only 2>&1")
    system bin/"velero", "client", "config", "set", "TEST=value"
    assert_match "value", shell_output("#{bin}/velero client config get 2>&1")
  end
end
