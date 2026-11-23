class SpiffeHelper < Formula
  desc "Tool that can be used to retrieve and manage SVIDs on behalf of a workload"
  homepage "https://github.com/spiffe/spiffe-helper"
  url "https://github.com/spiffe/spiffe-helper/archive/refs/tags/v0.12.4.tar.gz"
  sha256 "316c9c27959effc6eb6fd027112d642e56a00cae31c73be1f98c5ec02f2daea1"
  license "Apache-2.0"
  head "https://github.com/spiffe/spiffe-helper.git", branch: "main"

  bottle do
    manifest_sha256 "7608f1567aac806505dde62871045193e3f5cc881fa5fba242dc8290f7b9e52e"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f2f40134b38cc74a8cb5358a31a96b627899d8e54c3d77a7284d90ebc65b817c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f2f40134b38cc74a8cb5358a31a96b627899d8e54c3d77a7284d90ebc65b817c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f2f40134b38cc74a8cb5358a31a96b627899d8e54c3d77a7284d90ebc65b817c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8e679c3f142d9a508723f01b1bb2ad3668fca16d278678cea6086132ebac3961"
    sha256 cellar: :any,                 x86_64_linux:      "1d049cfe940c8e2269314be4cf038df75568337c69fcd7fb972c7dcea4bb594f"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/spiffe/spiffe-helper/pkg/version.gittag=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/spiffe-helper"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/spiffe-helper -version")

    output = shell_output("#{bin}/spiffe-helper 2>&1", 1)
    assert_match "helper.conf: no such file or directory", output
  end
end
