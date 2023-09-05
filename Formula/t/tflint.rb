class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/v0.48.0.tar.gz"
  sha256 "9643ea803796a01c9dcbd63b7f624a1d5499b258d79639c311738ab1ce67e1c2"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d3df859047a2bf2f7088ddde74ab83ed93016e030279d58de94c8ea4138c1fe7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77b57e445dd5abd39a18728a8bd14e025c90a00d0cdbba92496301cd40e4d95a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "560042656d499e3317f75b2dcbe56b9474b30ef73c1cb0179b6828e6f92ec511"
    sha256 cellar: :any_skip_relocation, ventura:        "0726a610750ca30b0949acf83b93ba4c145c32510e8d4096e11f5ec1d7b5ba01"
    sha256 cellar: :any_skip_relocation, monterey:       "2b66a73ef40b59f4503fbe0326a03fe3c1f29dae1ff71e01878c9a70932bada6"
    sha256 cellar: :any_skip_relocation, big_sur:        "6315500ba0d6a239414872fec1477b8c74a3f827bef1da32765bb006c0f84730"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8158f5a017903098f2d1c5d9f6f9ac0c0529706c89b1d28e8fbc5a58ae3be978"
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
