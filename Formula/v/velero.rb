class Velero < Formula
  desc "Disaster recovery for Kubernetes resources and persistent volumes"
  homepage "https://velero.io/"
  url "https://github.com/vmware-tanzu/velero/archive/refs/tags/v1.18.1.tar.gz"
  sha256 "ed9d9191f01f214e5e66b700b71c4ee7db728a6adeddbd8e097706444ee0308b"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1070f2d7934692ec9b1c662843ff21a0ab5c7ae534e1e575bc81636c3a98b9ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3141dac8da7505d5b2d3be51981aae212b22c0b11171fa36fa99f5d861c4890"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d730d2b353f20ff020d87b243bb4252d92dc1f261e2bfec272a57ea5a6485c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "b55bfebe115dd048924a2cbfbbfc037e50274f3b85544b816b868b2b18c06335"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2314cc4013a8930b2a1a0ad788a2e2613ba34786f1a1d36f7854c2d6c4d850e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b74f133bb7976ed946f97e6ef2f43665b58af74afa79bc3991895070caa897e5"
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
