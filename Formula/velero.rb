class Velero < Formula
  desc "Disaster recovery for Kubernetes resources and persistent volumes"
  homepage "https://velero.io/"
  url "https://github.com/vmware-tanzu/velero/archive/v1.11.0.tar.gz"
  sha256 "b7b3f5e21b3d665d5fcf483047ef5646d9bd755c219116cb9c4a979dd0908028"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce43630ae4daca32b245a613a50bc8f55103a9743e18c04ed920688d77ff0057"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce43630ae4daca32b245a613a50bc8f55103a9743e18c04ed920688d77ff0057"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ce43630ae4daca32b245a613a50bc8f55103a9743e18c04ed920688d77ff0057"
    sha256 cellar: :any_skip_relocation, ventura:        "434b9e477b0fa3ab97a883d9b9827e56b72efd9862faae12e7c3edabdc335bb8"
    sha256 cellar: :any_skip_relocation, monterey:       "434b9e477b0fa3ab97a883d9b9827e56b72efd9862faae12e7c3edabdc335bb8"
    sha256 cellar: :any_skip_relocation, big_sur:        "434b9e477b0fa3ab97a883d9b9827e56b72efd9862faae12e7c3edabdc335bb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb1834fac107afa1ff80f79199a80e0c7ce1081402e1582961a2e7945fd36c8a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/vmware-tanzu/velero/pkg/buildinfo.Version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "-installsuffix", "static", "./cmd/velero"

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
