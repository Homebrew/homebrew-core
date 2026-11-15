class Velero < Formula
  desc "Disaster recovery for Kubernetes resources and persistent volumes"
  homepage "https://velero.io/"
  url "https://github.com/velero-io/velero/archive/refs/tags/v1.18.4.tar.gz"
  sha256 "f551c797c90bc9e76f4de31e07011888666aeb63cd277991b909e4509baf9142"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e079634c642b84b138f12954ee98455f98551fe773eaf4c5cb2fa072c13c3b43"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2577a977fdb4fffb584f04ede49f160df6cd27d8ee0d238d0aaf6f6d9f0aaa74"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bbc1678b55230911c0b45f041c13e13f8c8e86b82932a25811ed48fd6484b2fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "eac4545e845af20ab8cb525a64a4ab8cd6355ec7d03e2005776513c127dfd76c"
    sha256 cellar: :any,                 x86_64_linux:      "06082880d77e8342cc65c24aefa05a28afbfc9ce78dc4b44427ad57af62f5251"
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
