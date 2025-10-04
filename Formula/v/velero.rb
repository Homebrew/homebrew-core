class Velero < Formula
  desc "Disaster recovery for Kubernetes resources and persistent volumes"
  homepage "https://velero.io/"
  url "https://github.com/vmware-tanzu/velero/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "5634ef389637ef4e254e5d9d41e7770b26b397836684588634fcbd9a7b25980f"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2da3a164b5adbfbac07483a7fc5716a4463b3faa6357312d867812b5ce3adf1d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e9d332e6a7f871d9662c57d48d7248e498c358ab44347541ac8fc7844a22c5d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f44c30f23d9531e9b2d2cf93afe7b767e3792ba96ebbd8d366bc61b4411a4757"
    sha256 cellar: :any_skip_relocation, sonoma:        "7bac20aec80c6b644a065993f18addca5ce3b8a666327ee4cfceb547ea5dadb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "992408148702639e9c6be5c4cb2d64a5ac4928cf7d0fb9d801b974dd7fc8e5f2"
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
