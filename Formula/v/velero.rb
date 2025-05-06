class Velero < Formula
  desc "Disaster recovery for Kubernetes resources and persistent volumes"
  homepage "https://velero.io/"
  url "https://github.com/vmware-tanzu/velero/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "28f60947c1eab5beff03d509b9d06550f3bc9bb3465a8a8a5ad7ae289637945e"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5937a18a9f77c7aed6e357bc2e0e414b9383566e71a597ef1a182a214347a463"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5937a18a9f77c7aed6e357bc2e0e414b9383566e71a597ef1a182a214347a463"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5937a18a9f77c7aed6e357bc2e0e414b9383566e71a597ef1a182a214347a463"
    sha256 cellar: :any_skip_relocation, sonoma:        "51c3fa715fdaa3768513661959be57da58a89b22469ca03563d64d9e2d7df502"
    sha256 cellar: :any_skip_relocation, ventura:       "51c3fa715fdaa3768513661959be57da58a89b22469ca03563d64d9e2d7df502"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3bbae02c1cd289cb6ab17c2ba8bbdbd2b81e61a4d6f604f2032b5ed121da15ca"
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
