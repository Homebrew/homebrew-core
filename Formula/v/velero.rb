class Velero < Formula
  desc "Disaster recovery for Kubernetes resources and persistent volumes"
  homepage "https://velero.io/"
  url "https://github.com/vmware-tanzu/velero/archive/refs/tags/v1.15.2.tar.gz"
  sha256 "dd874f286bc7b3a3f60f3486a4c318da26e6de3698e2daf66cd05a1f212b12cf"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fbf398fb64072cfb10dd2962caf0f3566849e5b3ba09335a3c894599ea0ab7b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fbf398fb64072cfb10dd2962caf0f3566849e5b3ba09335a3c894599ea0ab7b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fbf398fb64072cfb10dd2962caf0f3566849e5b3ba09335a3c894599ea0ab7b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d5c66efdde3533f8db8de4776b39188aa59842962df2f820483ec106ad97fdd"
    sha256 cellar: :any_skip_relocation, ventura:       "4d5c66efdde3533f8db8de4776b39188aa59842962df2f820483ec106ad97fdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f255cbc01189b119d9cbfcab08def224830805ee99f23869305f844a2f75c474"
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
