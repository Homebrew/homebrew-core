class Velero < Formula
  desc "Disaster recovery for Kubernetes resources and persistent volumes"
  homepage "https://velero.io/"
  url "https://github.com/vmware-tanzu/velero/archive/refs/tags/v1.17.2.tar.gz"
  sha256 "aca71da7ce8278e498b0b503aa504920bfa9e0a7f5d03916ce134a0700d95455"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5359dae5066183cc3f71881be44b58c62a75a3147aee69aab3f31675082c4ce5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39179393204680eabd75b21d95687ef0b5f0ef0f949884a5b66838e91be1c8ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "190affde9fac8cf8d73fedaf7c7fbca5a839d793e7fd80fb05b9466163f9d915"
    sha256 cellar: :any_skip_relocation, sonoma:        "3954553f1908e3125a1d4943022b6537d4eeb31cba169c22fd38f2a1a39a22bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92a7779e51c634c43a627ffed7b4bccae36289b908c1ffdae1e07d6bdb0c6ea4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da3124e1e3012160e973de911f001333ae6bf7d1f337bfc80becf585f06a1269"
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
