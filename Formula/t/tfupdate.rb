class Tfupdate < Formula
  desc "Update version constraints in your Terraform configurations"
  homepage "https://github.com/minamijoyo/tfupdate"
  url "https://github.com/minamijoyo/tfupdate/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "dafa61988cb736725474cf5eb901e2af18c7dab96100e17ac2a82e774236c340"
  license "MIT"
  head "https://github.com/minamijoyo/tfupdate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "272a3ea75cbbcb0eb2bf07db01e2c252fa0d882f53fd1177da9d051e4d42dfe7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "272a3ea75cbbcb0eb2bf07db01e2c252fa0d882f53fd1177da9d051e4d42dfe7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "272a3ea75cbbcb0eb2bf07db01e2c252fa0d882f53fd1177da9d051e4d42dfe7"
    sha256 cellar: :any_skip_relocation, sonoma:        "f656e6eb88b5cc7addcbc0f0860161040ce6b822eb743abcd32b1960b60d3655"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ced5adf6d96a9db07d2c1b99eff7847356d6f60e5162fcf3c9cfc92e0df517c"
    sha256 cellar: :any,                 x86_64_linux:  "1799ee47013e5027b1858d49a746ee39264cb53fa5c40643584876adf4173031"
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
