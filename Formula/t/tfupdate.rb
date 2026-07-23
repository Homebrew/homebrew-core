class Tfupdate < Formula
  desc "Update version constraints in your Terraform configurations"
  homepage "https://github.com/minamijoyo/tfupdate"
  url "https://github.com/minamijoyo/tfupdate/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "e5aa33dcf1840bd390aabb3d6c663d9d67ae8dd3592b8e22958f8e0db80d230e"
  license "MIT"
  head "https://github.com/minamijoyo/tfupdate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df0a365dbd7a1911699b157e2b45370b0844f4b1d6c23ae8372d08f639715ce0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df0a365dbd7a1911699b157e2b45370b0844f4b1d6c23ae8372d08f639715ce0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df0a365dbd7a1911699b157e2b45370b0844f4b1d6c23ae8372d08f639715ce0"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c73b9eab1fc925b5913773714e55d9a0d05d451df2e75f3c7c4b36e0efd5021"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4245903797e6660538753affd2e3a1de5752a8a8c44a36d96cb6aab76369e4f9"
    sha256 cellar: :any,                 x86_64_linux:  "47e000761944db7b9da0daf5e0e70591ea40afb34732c53c0f77b49a0222c3df"
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

    assert_match version.to_s, shell_output("#{bin}/tfupdate --version")
  end
end
