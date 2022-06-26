class Terraformer < Formula
  desc "CLI tool to generate terraform files from existing infrastructure"
  homepage "https://github.com/GoogleCloudPlatform/terraformer"
  url "https://github.com/GoogleCloudPlatform/terraformer/archive/0.8.21.tar.gz"
  sha256 "4f08b3d1f1fb36b9c979328445961e5e5990ae9026d823466fc8b9dd7982f027"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/terraformer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c99715b4de5cf4700cdea995b8dacc2528eefea7071759348364ad807708d23"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d8ab44c2ba5ea53cf68fd638c3d583bd4bf2e487d86017fcab026160825adbd3"
    sha256 cellar: :any_skip_relocation, monterey:       "8bdd20f5b2ed5f3d57d25a37d5e3495a83ec0de6e64cb958f08e29ccf34be270"
    sha256 cellar: :any_skip_relocation, big_sur:        "b6b7dd3d92b64698205d832faaf3361f33c2ee72c794ee01363c17fb71ecdd46"
    sha256 cellar: :any_skip_relocation, catalina:       "aea35c8c14758ba425fb096b392a7efafa4da55ade0e086baf23f13c19a38012"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2d11ab7a030bdc784b1051b8055ab64f066fc3b9332fdb6c25dd457d2d697b2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s,
      shell_output("#{bin}/terraformer version")

    assert_match "Available Commands",
      shell_output("#{bin}/terraformer -h")

    assert_match "aaa",
      shell_output("#{bin}/terraformer import google --resources=gcs --projects=aaa 2>&1", 1)
  end
end
