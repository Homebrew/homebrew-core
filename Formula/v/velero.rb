class Velero < Formula
  desc "Disaster recovery for Kubernetes resources and persistent volumes"
  homepage "https://velero.io/"
  url "https://github.com/vmware-tanzu/velero/archive/refs/tags/v1.13.1.tar.gz"
  sha256 "a71d775bcee08af9f3518ba920b6e2bc905863acbeedacbac80913b5e74164c6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2e4cb433beebf39fe54746b0a8b9ae385487bcbcde5564c8f1fdedcd72efa95e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "93e70e351609fa5bb37c321eb5e8a3c6f35b935ac3284df2e2433623eca8989d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a17ab6a953525357b005fd4ab86826c0bbf1a8069adb73cf049c7fa4c263d984"
    sha256 cellar: :any_skip_relocation, sonoma:         "2f732775f9e26130c41dcca6888fded60a8da9a837b4f73031f4d16647957eb9"
    sha256 cellar: :any_skip_relocation, ventura:        "e6950437e1f099d06be24f8875e13dcbd76a2cc84877f3b334665f0f093c651a"
    sha256 cellar: :any_skip_relocation, monterey:       "87339f64b0cd43775bcc4beba14048e433f61bb3ca7399bd43e30fff4e09a2b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5931a90c9c85dd154371b93bad102f87b60c0925745444901250da846a8b3f57"
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
