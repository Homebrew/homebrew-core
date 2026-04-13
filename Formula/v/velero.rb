class Velero < Formula
  desc "Disaster recovery for Kubernetes resources and persistent volumes"
  homepage "https://velero.io/"
  url "https://github.com/vmware-tanzu/velero/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "e94e51437b7cc54b633fcd253d5003494382e4de69c34992463588f248ba409c"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d138af20ffb434ad4bf2030f34c374212c746a094184dc62b2ff91527a6ca90c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d90c69da2593b9d313e37f737f8666165ed91816905124bd38309e58a1caf9bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47ce023ef1bc337abc58f19b006b51be911819d174ec818cf313434d70777c15"
    sha256 cellar: :any_skip_relocation, sonoma:        "909b5f726a91247c9f972d5bea1e4f0113fe130307b6b455eb66fbd29b3c69b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a1679d9cce7f2eeb9905c38aa414db99ab982f09f68ce5dc3ad6ec6c1d339bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97eb510dc359a1e34f903723293fe82a9814fb5b9df050674f2a4884aecae0a0"
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
