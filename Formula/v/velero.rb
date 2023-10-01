class Velero < Formula
  desc "Disaster recovery for Kubernetes resources and persistent volumes"
  homepage "https://velero.io/"
  url "https://github.com/vmware-tanzu/velero/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "dc8579c6938e803fd74bcf8e463a61b1f22971ad4f2b2be25d55bd05486ce1da"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4a9942dd6b2690504db187dcbf8995d81dbe016c3d588fa02077c1616e33a143"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d82dbb68f0149463f1ca239d09a2110115113cac091af410fece3ea79bae687c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a95561ca9360d8b294ba8d7b1e691442a72cb09a4a49a532a1577cd82fe22d14"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ac530e04f119ab9c7926c196476e7a03881452c10d6f1bc6a9045c70811db734"
    sha256 cellar: :any_skip_relocation, sonoma:         "a2495af67629bb0450f5c97378671ffdd92592aad96b197f18eeeb27596872f4"
    sha256 cellar: :any_skip_relocation, ventura:        "6bead351e3d4e1cd42c1faf030de440d0c3c062945ef9bbf453b3c92abf1e36b"
    sha256 cellar: :any_skip_relocation, monterey:       "bc2790b3117f4b2d83547fea5da17e4cd564e834b39fbb5c0f49158f25c0b1ea"
    sha256 cellar: :any_skip_relocation, big_sur:        "2a7e3a74cd211d1d51109a1968e3b2a28d60d3414eaede6fa5e190ed51dd3597"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4854431a759218bbade3b0f221518513c37fde5ce3511872fbe8d1b7c328522"
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
