class Tfupdate < Formula
  desc "Update version constraints in your Terraform configurations"
  homepage "https://github.com/minamijoyo/tfupdate"
  url "https://github.com/minamijoyo/tfupdate/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "0d9820f93f9f80c17e01da8bd3f4256642e93c86a1356b5d4418cb93797ec95d"
  license "MIT"
  head "https://github.com/minamijoyo/tfupdate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00d282c53811c76412b0e2b70e46ebed61000da5ad00626b685746c4c5c751bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00d282c53811c76412b0e2b70e46ebed61000da5ad00626b685746c4c5c751bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "00d282c53811c76412b0e2b70e46ebed61000da5ad00626b685746c4c5c751bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "e64ef15ad842060603995ea401b5c2076fecc986a847ce0561f37c786e956e09"
    sha256 cellar: :any_skip_relocation, ventura:       "e64ef15ad842060603995ea401b5c2076fecc986a847ce0561f37c786e956e09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76812d8345297e0e89375753cff0dee7a3b1def82bd9b8e7c41caa9f15e2ae99"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"provider.tf").write <<~HCL
      provider "aws" {
        version = "2.39.0"
      }
    HCL

    system bin/"tfupdate", "provider", "aws", "-v", "2.40.0", testpath/"provider.tf"
    assert_match "2.40.0", File.read(testpath/"provider.tf")

    assert_match version.to_s, shell_output(bin/"tfupdate --version")
  end
end
