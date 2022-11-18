class Velero < Formula
  desc "Disaster recovery for Kubernetes resources and persistent volumes"
  homepage "https://github.com/vmware-tanzu/velero"
  url "https://github.com/vmware-tanzu/velero/archive/v1.9.3.tar.gz"
  sha256 "294f63c2382c5c6570c5db8b20087e8053e5572b5bef7b4ec1df5db3d565c08b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9ac11ea8d9f84617c071b63c00b963a70aec238f0d665a75d99d227e54bafeb2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "749341bd92efcffcc90f2ba8361a36b772d1ff94b0f66bf39a9fc925cc72250f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a4fb442951ee485f442c221904ca59591142e09ffea3edb687b8d630ee3b4771"
    sha256 cellar: :any_skip_relocation, ventura:        "34cb83c792d234957508c52dd12b837ab702a0e5bb3dbd2191aac08bb4f2fb15"
    sha256 cellar: :any_skip_relocation, monterey:       "cc2769d44cbd216728b996bcfc2fc4e27d5d18fb973d021187d6ec12c71a9882"
    sha256 cellar: :any_skip_relocation, big_sur:        "3ea7eebdbf751e2050bd5c212178ff864410cba435222db8036370119a6c54d9"
    sha256 cellar: :any_skip_relocation, catalina:       "ce40dfce5c1a3488accf25794bc67dbde1799f2c48aaadada003fdfa41ca6c5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e950c979ae5e82f9e0420cb7d6f070161f9346a880f3d88f985d1654e4729519"
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
