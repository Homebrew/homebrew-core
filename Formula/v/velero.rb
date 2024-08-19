class Velero < Formula
  desc "Disaster recovery for Kubernetes resources and persistent volumes"
  homepage "https://velero.io/"
  url "https://github.com/vmware-tanzu/velero/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "236b84ca4a87906adfc727f3b30819369d4321f4dfd49675438c3321ebb990e8"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0cc210ffa1888bb030a4784f03f03d760345cc651c18da1beb689268be31010f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "62489f705e77a7244b9de11cb5dbaf2046c848c7f21eea54c26a44554b332d1b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c513eaadda86340d75026df8719e9c96fa437ac86e17ad167c35e4299dc9700"
    sha256 cellar: :any_skip_relocation, sonoma:         "378880a7363c6224c8d84aa7681b55f8591c20628359052eae1c3711d33e8ebd"
    sha256 cellar: :any_skip_relocation, ventura:        "e7a508524b9e7cfd722d2d8419b7d2c950ee0ed63ebd46ba648b571fa8c34a61"
    sha256 cellar: :any_skip_relocation, monterey:       "791e49e21e79c05ab790c714b73ccc95f66fec3303e03b474cb46c0f0c0ab939"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50be6ea2c2d17e363d7b828787a6d5a6493ae5fff9251b1b7b137cb429848931"
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
