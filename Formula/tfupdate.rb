class Tfupdate < Formula
  desc "Update version constraints in your Terraform configurations"
  homepage "https://github.com/minamijoyo/tfupdate"
  url "https://github.com/minamijoyo/tfupdate/archive/v0.6.4.tar.gz"
  sha256 "ee55baed73ccfe43fee8d7214e3f04e2179611c0b058a22f4be6d89797441fb9"
  license "MIT"
  head "https://github.com/minamijoyo/tfupdate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "638047caf1f628fcec6582b0c68b8375a686b4bf9d5a5ae985fa62a93144b96e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "feae683aabba444a9b6c390fe00180978e528e76f5d394b3aeae99266229ad34"
    sha256 cellar: :any_skip_relocation, monterey:       "9379d9cdffb6841d83a0c69dcdd5d9d300cb41a9f283873c4142c5168d91b676"
    sha256 cellar: :any_skip_relocation, big_sur:        "a16b8c44ed0026e46c483514afae55b3fed2c904ad670066258303ee98b6f551"
    sha256 cellar: :any_skip_relocation, catalina:       "f29b6f73d35629aef5776535a4d39a373ced7fc923bac95f5f8bff6c7fc35f88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "576c712d91ee88bd224d75e85e60cffefc6f8873d9ea2409bd337341bfbe9ec0"
  end

  depends_on "go" => :build
  depends_on "terraform" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"provider.tf").write <<~EOS
      provider "aws" {
        version = "2.39.0"
      }
    EOS

    system bin/"tfupdate", "provider", "aws", "-v", "2.40.0", testpath/"provider.tf"
    assert_match "2.40.0", File.read(testpath/"provider.tf")

    # list the most recent 5 releases
    assert_match Formula["terraform"].version.to_s, shell_output(bin/"tfupdate release list -n 5 hashicorp/terraform")

    assert_match version.to_s, shell_output(bin/"tfupdate --version")
  end
end
