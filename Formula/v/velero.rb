class Velero < Formula
  desc "Disaster recovery for Kubernetes resources and persistent volumes"
  homepage "https://velero.io/"
  url "https://github.com/vmware-tanzu/velero/archive/refs/tags/v1.14.1.tar.gz"
  sha256 "72e22657b41af1ac9d7678925b51b570e297a2f8763d64b17c8e46a5b4f3c2d5"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "5c0adaea93ab960034301865cdfb8275a7f6cb22f32a1a482a45f87818d52fe4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e2a645c0ffd37d65a4470edfb7d7700b92d40be61505ad0c7766413a6a5f52ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e2a645c0ffd37d65a4470edfb7d7700b92d40be61505ad0c7766413a6a5f52ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2a645c0ffd37d65a4470edfb7d7700b92d40be61505ad0c7766413a6a5f52ca"
    sha256 cellar: :any_skip_relocation, sonoma:         "772aef7e1fbefca93b26d8c49d64ec0011a4ea8db3549ccf5f47cc3bbefeb4a5"
    sha256 cellar: :any_skip_relocation, ventura:        "772aef7e1fbefca93b26d8c49d64ec0011a4ea8db3549ccf5f47cc3bbefeb4a5"
    sha256 cellar: :any_skip_relocation, monterey:       "772aef7e1fbefca93b26d8c49d64ec0011a4ea8db3549ccf5f47cc3bbefeb4a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c37aab45152d5ebac1c320bf556fd2239c497094f48bbadcb45deafa71296008"
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
