class Velero < Formula
  desc "Disaster recovery for Kubernetes resources and persistent volumes"
  homepage "https://github.com/vmware-tanzu/velero"
  url "https://github.com/vmware-tanzu/velero/archive/v1.8.1.tar.gz"
  sha256 "675034d30d3539f9292ca5896e28df6159cdf1c6436d806795a79c61bfe37cd7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42b19180fd9b86734fd6d7c39fa95e4a4636dc42c9ef5742178102b3f0098789"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e6b17b32930d1811fb56e6ae859a2681f825d6df9a922649873398a8422e598d"
    sha256 cellar: :any_skip_relocation, monterey:       "2630b1f359fb7c87c63b473a13c7627ca0b6f98be5872f121f6ee713c0ab2105"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a32b4e95b9ccc0907617b43042adab16f0e5ee70f104adefdeed89bbb6e575e"
    sha256 cellar: :any_skip_relocation, catalina:       "2f4c9fe8487bb5d41ad490a874a2fbb079f36af40d903e9f4227602b130280db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "400c333480ab725a42acd9fa3c3061fd9c1c69a36f5762360b6bb406a9cceec8"
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
