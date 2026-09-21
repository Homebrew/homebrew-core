class Velero < Formula
  desc "Disaster recovery for Kubernetes resources and persistent volumes"
  homepage "https://velero.io/"
  url "https://github.com/velero-io/velero/archive/refs/tags/v1.18.3.tar.gz"
  sha256 "63ce48e63ae9104e241d323d098e49953ec1659ef243518de292bc479846d74b"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6723008fa7d48f18b1a8d04aab298942edefc17cf6900e409135cc27e4b373f4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b245156c7afdb09d785cf4673ef0323fe3fc94ac88b6bfd115dbec68761cddba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1f6af2dd027165e248bef43106302931051c5a22ba1aea748ef6980812ef5edd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6e4999d44509cc41bdcf77426d6aaf9e5c5b95dd420f34584edc1a06913faed3"
    sha256 cellar: :any,                 x86_64_linux:      "0ee161de05cd618956d496a0b1fc1b5101d730cae7d48a4621e79e125095fc3a"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/vmware-tanzu/velero/pkg/buildinfo.Version=v#{version}]
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
