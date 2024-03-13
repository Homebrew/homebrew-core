class Velero < Formula
  desc "Disaster recovery for Kubernetes resources and persistent volumes"
  homepage "https://velero.io/"
  url "https://github.com/vmware-tanzu/velero/archive/refs/tags/v1.13.1.tar.gz"
  sha256 "a71d775bcee08af9f3518ba920b6e2bc905863acbeedacbac80913b5e74164c6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ea296bf9590e660103909e784e459a04042a6a76f3cd80244d34429addf309a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef6717596c5fdc9bb857e22936b180f5a8285c789232d596f900910eebdd4caf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12b8a88fe5c8c208cc6a63a99c8118ff267975049dab3054e075c0f7cbc705c8"
    sha256 cellar: :any_skip_relocation, sonoma:         "07fcc7302b7950db2c7f992ed371786a9608d0c073e519706190fe85561ffa6e"
    sha256 cellar: :any_skip_relocation, ventura:        "387c94010cf6192f5dd8bd8637505b3819c9758a3123fb1d236f679e18517df2"
    sha256 cellar: :any_skip_relocation, monterey:       "6eb724be21560e4f0fda449bb7ef4aed3c0e101cc9b300a9bc98643b2ca3e39c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e088bfc7f5002c4c3db4f50f16aa678e5033162ec8dcb9d4722c23b1a45def7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/vmware-tanzu/velero/pkg/buildinfo.Version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "-installsuffix", "static", "./cmd/velero"

    generate_completions_from_executable(bin/"velero", "completion")
  end

  test do
    output = shell_output("#{bin}/velero 2>&1")
    assert_match "Velero is a tool for managing disaster recovery", output
    assert_match "Version: v#{version}", shell_output("#{bin}/velero version --client-only 2>&1")
    system bin/"velero", "client", "config", "set", "TEST=value"
    assert_match "value", shell_output("#{bin}/velero client config get 2>&1")
  end
end
