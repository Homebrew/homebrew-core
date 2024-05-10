class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/refs/tags/v0.51.0.tar.gz"
  sha256 "267709751980856e9a78fe592470c6a780e800d1633e23bed359f243f7e6920e"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3ffc1321025d1b9070b98f2e575cdee08c7194c53cd1e8c4763a71f20c9d9441"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4d9346499e413786ed2ec849d69b5962d639aa8ac1fa910dd99dc66b3b41b868"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6324e92d8fd73f9cb73877a79987492de6267130ddbe622b427ca385a46e922d"
    sha256 cellar: :any_skip_relocation, sonoma:         "be06f9283bd0a88da82abed198058a4899fc15f91d5f6dc446700ce77b9f57a4"
    sha256 cellar: :any_skip_relocation, ventura:        "2953389c9226d7392fb600594b7e99b1987e7f23b085adae7419b2afc3304f0d"
    sha256 cellar: :any_skip_relocation, monterey:       "e293bbb262fa1ceca327cf6f91d5885db01fe0da32709d489d10816583ce953c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "657e14788e35ffdb3cc946a9618f26ac19e5d8dee23deca200689f2f0335432e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"test.tf").write <<~EOS
      terraform {
        required_providers {
          aws = {
            source = "hashicorp/aws"
            version = "~> 4"
          }
        }
      }

      provider "aws" {
        region = var.aws_region
      }
    EOS

    # tflint returns exitstatus: 0 (no issues), 2 (errors occurred), 3 (no errors but issues found)
    assert_empty shell_output("#{bin}/tflint --filter=test.tf")
    assert_match version.to_s, shell_output("#{bin}/tflint --version")
  end
end
