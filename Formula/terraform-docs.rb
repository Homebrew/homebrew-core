class TerraformDocs < Formula
  desc "Tool to generate documentation from Terraform modules"
  homepage "https://github.com/terraform-docs/terraform-docs"
  url "https://github.com/terraform-docs/terraform-docs/archive/v0.13.0.tar.gz"
  sha256 "f1d05a31c9257959f505cac9e90089f70560e944edf3202e1d89a8fe7af5d152"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "63457def81053d4fdd081e40a0e1d8a81ead6f83767de8b08c14241672c579cd"
    sha256 cellar: :any_skip_relocation, big_sur:       "e2f72b98a3686ca300ccae49189a9a434c71b45b7a00f810d9d1cc5ff3c97af0"
    sha256 cellar: :any_skip_relocation, catalina:      "455ff789dc766f3c8adcc139d7c233640293d73a669d2e4b3b1a1aedd7e35ac1"
    sha256 cellar: :any_skip_relocation, mojave:        "cc2d7b490cbfc62fc208cbb5e231009999bfedba85f2f45e5448b9d99ead3f0b"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    cpu = Hardware::CPU.arm? ? "arm64" : "amd64"
    os = "darwin"
    on_linux do
      os = "linux"
    end
    bin.install "bin/#{os}-#{cpu}/terraform-docs"
    prefix.install_metafiles
  end

  test do
    (testpath/"main.tf").write <<~EOS
      /**
       * Module usage:
       *
       *      module "foo" {
       *        source = "github.com/foo/baz"
       *        subnet_ids = "${join(",", subnet.*.id)}"
       *      }
       */

      variable "subnet_ids" {
        description = "a comma-separated list of subnet IDs"
      }

      variable "security_group_ids" {
        default = "sg-a, sg-b"
      }

      variable "amis" {
        default = {
          "us-east-1" = "ami-8f7687e2"
          "us-west-1" = "ami-bb473cdb"
          "us-west-2" = "ami-84b44de4"
          "eu-west-1" = "ami-4e6ffe3d"
          "eu-central-1" = "ami-b0cc23df"
          "ap-northeast-1" = "ami-095dbf68"
          "ap-southeast-1" = "ami-cf03d2ac"
          "ap-southeast-2" = "ami-697a540a"
        }
      }

      // The VPC ID.
      output "vpc_id" {
        value = "vpc-5c1f55fd"
      }
    EOS
    system "#{bin}/terraform-docs", "json", testpath
  end
end
