class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/refs/tags/v0.50.0.tar.gz"
  sha256 "4c6e487a706e9cf6ef046ef6798a1d7a18a5ecc4b6bd2b4d60ba5c999bcda716"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "31ae0c3c14bcaec118fe6a5e50d99bf9154944b9202fcacd4777a820ffe4afcf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9ebfa7968db7b71a535ff9f597e61d189d263863797dd4af9499ea90a495880d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f8bc72236b25d7a99b97f81fd6d6e95f652ca977547abaf91dfebe17c8b6ebb"
    sha256 cellar: :any_skip_relocation, sonoma:         "9ac2880e67919586d22b7ffb4fbfebe93535a56f0553bd073878e802c59b37fc"
    sha256 cellar: :any_skip_relocation, ventura:        "1bada8be4cb76004551d3eb4baee8f6856cde88584526e7418c9c5527d041897"
    sha256 cellar: :any_skip_relocation, monterey:       "da434a447315d7303bcf19c513a2cb84f50fb347b84e82cc19e2071dc7831999"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2aed36f3adefe49102b9983d933a4856617b8a0976a0a98fd1d3db152355a501"
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
