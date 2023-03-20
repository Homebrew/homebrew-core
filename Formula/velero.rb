class Velero < Formula
  desc "Disaster recovery for Kubernetes resources and persistent volumes"
  homepage "https://velero.io/"
  url "https://github.com/vmware-tanzu/velero/archive/v1.10.2.tar.gz"
  sha256 "01de9610a55019c798245cbff1bbee1477e5d53f055125b3c7045cddc091444c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "50143a4670e6334ada59d2cad209212a725ba10ae52cb5cc435803559e98ca09"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50143a4670e6334ada59d2cad209212a725ba10ae52cb5cc435803559e98ca09"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "50143a4670e6334ada59d2cad209212a725ba10ae52cb5cc435803559e98ca09"
    sha256 cellar: :any_skip_relocation, ventura:        "879d1d16619f4278f2fa75c729d1d5340f5a5936314dda055c2c58c01204bb97"
    sha256 cellar: :any_skip_relocation, monterey:       "879d1d16619f4278f2fa75c729d1d5340f5a5936314dda055c2c58c01204bb97"
    sha256 cellar: :any_skip_relocation, big_sur:        "879d1d16619f4278f2fa75c729d1d5340f5a5936314dda055c2c58c01204bb97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec1b5eb3853845fefcdae9b58b2fdf2072176ded98d2026d7e975baca3c67065"
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
