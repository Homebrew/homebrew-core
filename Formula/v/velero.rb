class Velero < Formula
  desc "Disaster recovery for Kubernetes resources and persistent volumes"
  homepage "https://velero.io/"
  url "https://github.com/vmware-tanzu/velero/archive/refs/tags/v1.17.1.tar.gz"
  sha256 "bc5008588b86255f1d7ced93dca2497e8656da75bd16644cf6252d48a46eac56"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "61cfb2d6f739b935cba875c859b5cc790bc6386d1bd8dcbfc43528c665641b6c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "daaf56080f799af86cd3cfbad40e76fa449a2c1f68d63c074e2f9bebbe653899"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "143781124c20fc2dbd95417d9fbe4dd456cdb1a892005dff79b0f54ae7415ff8"
    sha256 cellar: :any_skip_relocation, sonoma:        "abceb9aae5201d3ac2bb33cfa9e37b3720df6a22ac0c5c24e95c4a6c74ef2891"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "382957611dd33c59853029427009f6f6aace26cc8b8e6d6b14090340141b9e8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59c8e9b5e127bf9fb625317d95723659f9d78aa4383668049789a49acbe6fd58"
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
