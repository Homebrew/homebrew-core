class TerraformDocs < Formula
  desc "Tool to generate documentation from Terraform modules"
  homepage "https://github.com/terraform-docs/terraform-docs"
  url "https://github.com/terraform-docs/terraform-docs/archive/v0.10.0.tar.gz"
  sha256 "8d2a543c69b15b30247b5d88e544bb45bed5c4b967db38d6debd2754d1a80598"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "07e6bc6850459581f65fc59b0bc1152fbd917c7a760fc2e7203c55bc581bcbc7" => :catalina
    sha256 "a91bb362006421c48eb1f6c251b5515bce6930f9611d116469fea0390966531d" => :mojave
    sha256 "27b5477a3af7c8cdd53ba80fbf86309a65deeb8668dc010cd88cb0cb872272fb" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "bin/darwin-amd64/terraform-docs"
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
