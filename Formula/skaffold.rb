class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v2.1.0",
      revision: "c037d6f51276e178a2c05c1c59665956ff34aa4c"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d08fde1c8fec4c82c4f6d080a596e61230e68dd6ecbd62daf8858a1c35a3aef6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d73bfdea9adf4e8f51e6213536fc6e4ecf98fc53fe4420beca39430f3ded82c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "762fab1c47520f7c9b744f88acaf43692f999797b1e4c88d4d9a387171b1bd8e"
    sha256 cellar: :any_skip_relocation, ventura:        "2b63cbb40929d8177893d54fdbe84b4cf2d79ef453e607de2328073177908f38"
    sha256 cellar: :any_skip_relocation, monterey:       "82c007ecc2d70e4af37b6824fc4f9c2d928200ad61f57ae5878227cbce33bbbd"
    sha256 cellar: :any_skip_relocation, big_sur:        "e7210fe85c14b2b1fe912881058b623881b0f9f3c162ad134d9cf3e92adb633e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a6c6403dee3cbc108229fbcda13f458af7830ad229b407545cecc67ffa5c44f"
  end

  depends_on "go" => :build

  def install
    system "make"
    bin.install "out/skaffold"
    generate_completions_from_executable(bin/"skaffold", "completion")
  end

  test do
    (testpath/"Dockerfile").write "FROM scratch"
    output = shell_output("#{bin}/skaffold init --analyze").chomp
    assert_equal '{"builders":[{"name":"Docker","payload":{"path":"Dockerfile"}}]}', output
  end
end
