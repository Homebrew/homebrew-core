class Velero < Formula
  desc "Disaster recovery for Kubernetes resources and persistent volumes"
  homepage "https://velero.io/"
  url "https://github.com/vmware-tanzu/velero/archive/refs/tags/v1.16.1.tar.gz"
  sha256 "7ed017a714848371fbdf43c168218c58aaeb9afe90709d734483ec9825cbba6f"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8e018f4d140be1874c93a7072bade54277ed5781bd292d986916b0b2cba0a00"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8e018f4d140be1874c93a7072bade54277ed5781bd292d986916b0b2cba0a00"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d8e018f4d140be1874c93a7072bade54277ed5781bd292d986916b0b2cba0a00"
    sha256 cellar: :any_skip_relocation, sonoma:        "396383189ab5332b706963876a8d5b70d8acb1caf8f89eb8a4d3e358c46447f7"
    sha256 cellar: :any_skip_relocation, ventura:       "396383189ab5332b706963876a8d5b70d8acb1caf8f89eb8a4d3e358c46447f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5cb5a1d79406b69ef292edcd7d7363bfdeccf93eb2c75e23fa2d0b79d492b080"
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
