class Velero < Formula
  desc "Disaster recovery for Kubernetes resources and persistent volumes"
  homepage "https://velero.io/"
  url "https://github.com/vmware-tanzu/velero/archive/refs/tags/v1.18.2.tar.gz"
  sha256 "68d8c95817d882b2832c4c08689eb5f7b14dd581f71292a6c794acd15633b6d9"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5807c3e8ff2c6f38845127a1a11eea30962cdaaffeeac42d715e73d0c59354ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9355be9150f7cf4441826ab163e151013aad947416340b6b60b4e0aa22d3709c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e50a8f9b9a18fdb3fc18915b8b4896e3fdfef35110464e5989a0d7de22dd1072"
    sha256 cellar: :any_skip_relocation, sonoma:        "02f165b2c27f281bbd41cf7060e1482a02e2dde2d1d5e22b5c82993b64536fc3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c73dce7dc888ec67a8990e2054745c1f45f050470dec645958462fbef8b0a7e4"
    sha256 cellar: :any,                 x86_64_linux:  "c069033f761a035e739e91f96fb920cd7419342afd2c9728f2f35b809ff82a9c"
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
