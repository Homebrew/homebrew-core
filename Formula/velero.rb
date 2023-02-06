class Velero < Formula
  desc "Disaster recovery for Kubernetes resources and persistent volumes"
  homepage "https://github.com/vmware-tanzu/velero"
  url "https://github.com/vmware-tanzu/velero/archive/v1.10.1.tar.gz"
  sha256 "600d9fe7df5bff8c16b0f675f18389283e012eeb0fd92b519fc3cb3fbbbda484"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c54af8d501fa971fbbef5b80980a4cf94354a4797c134c4d8e573716ee5ffd31"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3501d73859f630fa2074584b6ff39bb1fb9c5c3efe0dbdad78b806060d8e8a4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0a3d308fa3cbddc7a056997a62ce57685335b702e45cafc2c0f77996e07108fe"
    sha256 cellar: :any_skip_relocation, ventura:        "f3eefcadd74a868a00e648c3b57841d79273b28221ff069ee12b1838711b97b9"
    sha256 cellar: :any_skip_relocation, monterey:       "3b0b0d1a2a98c320b5350e86893a5361b68552b7d9d5160b7e59b9d7d9a373e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "cf79ae529e6d7f1b260f7d3660e9f267bd01e4a72b0d860a509d4777ea8f3d10"
    sha256 cellar: :any_skip_relocation, catalina:       "bcdbf769f38b5289ac582213f4226a4006d821f427b8692a50a602b032de9d03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac38f76bcb5c01c792a4e151095dfd5e12438238450b2e9c956c7145cbc47534"
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
