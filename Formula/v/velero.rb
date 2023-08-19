class Velero < Formula
  desc "Disaster recovery for Kubernetes resources and persistent volumes"
  homepage "https://velero.io/"
  url "https://github.com/vmware-tanzu/velero/archive/v1.11.1.tar.gz"
  sha256 "5bc67f1277b60a4acf7a6beb0cc483a1d31643b0745624ad2f76fa3f0235988b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1aabb1449254ec88622e8d031446cb30b79e56fea9f1544530492284e9c4a8cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1aabb1449254ec88622e8d031446cb30b79e56fea9f1544530492284e9c4a8cd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1aabb1449254ec88622e8d031446cb30b79e56fea9f1544530492284e9c4a8cd"
    sha256 cellar: :any_skip_relocation, ventura:        "a1016afe7362e7b3e29e9d2ea55cca708ea3ef3cc3c16a1b69fd55739308de68"
    sha256 cellar: :any_skip_relocation, monterey:       "a1016afe7362e7b3e29e9d2ea55cca708ea3ef3cc3c16a1b69fd55739308de68"
    sha256 cellar: :any_skip_relocation, big_sur:        "a1016afe7362e7b3e29e9d2ea55cca708ea3ef3cc3c16a1b69fd55739308de68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd425802803f3fa654c76a3b7b6fd5baaa14b3dc3ead4b3f7b00f76a06b1908c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/vmware-tanzu/velero/pkg/buildinfo.Version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "-installsuffix", "static", "./cmd/velero"

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
