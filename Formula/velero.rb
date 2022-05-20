class Velero < Formula
  desc "Disaster recovery for Kubernetes resources and persistent volumes"
  homepage "https://github.com/vmware-tanzu/velero"
  url "https://github.com/vmware-tanzu/velero/archive/v1.8.1.tar.gz"
  sha256 "675034d30d3539f9292ca5896e28df6159cdf1c6436d806795a79c61bfe37cd7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d5e7dd1ec446795b48ee1216e986c73fb30a8578ac8c2ce4302189e5e41d0d3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "867c35bbc9c2c4cb084c88234979161ed92232c0fe86104e8aec4803b51182d3"
    sha256 cellar: :any_skip_relocation, monterey:       "62f38614bdb6942df5c685c51c960f990e22121affdc612d8ceb42823f1586ce"
    sha256 cellar: :any_skip_relocation, big_sur:        "84261d846c7d13f02a9ddb406fb6f9037388dab17bfd7da28ac4b36dbfc2ef07"
    sha256 cellar: :any_skip_relocation, catalina:       "72b446ff30792fd7e486ddd0a106dd4a74a27321fb7d597fd407160005ac1846"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9d3245f03f0a719fb9d0e2621f3c1ef6a27936fed7650fe5ee9b0a419dc2b75"
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
