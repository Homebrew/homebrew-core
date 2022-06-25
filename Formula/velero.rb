class Velero < Formula
  desc "Disaster recovery for Kubernetes resources and persistent volumes"
  homepage "https://github.com/vmware-tanzu/velero"
  url "https://github.com/vmware-tanzu/velero/archive/v1.9.0.tar.gz"
  sha256 "ad2b40ee7e80fb23b9e5b887d0dbc6ee49d4a708af8372e502872a157d30ed50"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c4fef74c83b07c1d9d195554c924ff4adb90705abb0bbde7f5b1ab799a45ac4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c7b96f49e100f98d138ce47b2ffeb2098695791d7db254bdfc010a4475376512"
    sha256 cellar: :any_skip_relocation, monterey:       "7c91d88283327d154e2438639b91dc58ce71a2e81dec0396193bb591be20d0ae"
    sha256 cellar: :any_skip_relocation, big_sur:        "4999a63622ff95f83af7749c48a66debe93ac7e31bc34520a30a8c171bce55db"
    sha256 cellar: :any_skip_relocation, catalina:       "0c0feb320ab1f409e259663707bd95da3054e78376bc399c9eb85874a8c642e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8c6fe417db6d1422ecf596501c470d24697461e2a320bfee06f67e793857d97"
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
