class Velero < Formula
  desc "Disaster recovery for Kubernetes resources and persistent volumes"
  homepage "https://github.com/vmware-tanzu/velero"
  url "https://github.com/vmware-tanzu/velero/archive/v1.7.1.tar.gz"
  sha256 "f008ea2ed6b5f03419399289768db907ec993f4c6ef6947689737d67d4a895b8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4aeef8b082ff57608666b2e81a606997699d6b9617c59af08f649678a67d99f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a269259419a540292e7f63f90c52af53a289ba928af445427f6dc528d850e4df"
    sha256 cellar: :any_skip_relocation, monterey:       "44492998753e5ad53f300a575747d8fba3012d70715acfd045f5d9e43d3caef0"
    sha256 cellar: :any_skip_relocation, big_sur:        "cb66509c1c8d0f0de93b3ecf683e95843e8c50d1855cdc3de05add3851986dc5"
    sha256 cellar: :any_skip_relocation, catalina:       "eecacf4e67cceff0d1b087c37614bc5513f3532ded33d77ec50fa974a2999860"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34c17c8ba1cebd7e21225bcffc5e4f7ae6962e34d013a71491dbc1ad97175f36"
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
