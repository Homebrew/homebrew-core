class Velero < Formula
  desc "Disaster recovery for Kubernetes resources and persistent volumes"
  homepage "https://velero.io/"
  url "https://github.com/vmware-tanzu/velero/archive/v1.10.2.tar.gz"
  sha256 "01de9610a55019c798245cbff1bbee1477e5d53f055125b3c7045cddc091444c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7763c4f84bd1f0be6ba2a1c79e3a9c0e7a9a8cf71ba86a3e0375d4fc306eab4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f9afbf1cc8ae709346415c734190ad6a1db9dd13868856fa7d442f44b570903"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "91ee84df3721008a7e7e3dfe40a32ab2ea53eff6eb4917dcd5955ee27dcca2cc"
    sha256 cellar: :any_skip_relocation, ventura:        "0033c5a51ea4cab15547d58bc9d0f035a6e984d7f71992e345f58af676776673"
    sha256 cellar: :any_skip_relocation, monterey:       "915673972cc7df4e8cad6db0e49aa17bd3f310cbf41bd9a901f2b46bf4367c49"
    sha256 cellar: :any_skip_relocation, big_sur:        "d6b9a2b33bcb927b9a221b08f7e08a789cae9475b0f43f7cda5f3453addc4e33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47e63956941d3eed3a04d65f43ff1bfb6b66d182f195547a3e22d61660927518"
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
