class TerraformDocs < Formula
  desc "Tool to generate documentation from Terraform modules"
  homepage "https://github.com/segmentio/terraform-docs"
  url "https://github.com/segmentio/terraform-docs/archive/v0.8.0.tar.gz"
  sha256 "2160af3face994d7219c59f5874b5a5b0df762f73d1e27bab67b857f40b64516"

  bottle do
    cellar :any_skip_relocation
    sha256 "fcb055e343d490f7247fdb918e6e9398ccada89e261036acbc0d2df60e5adc6d" => :catalina
    sha256 "176426293dacdf4ed8f4572dd59b502adf60a64ed17ead8176a32478f4a2b969" => :mojave
    sha256 "71c1705081953b0dcbed298fb61b1c413f22fa08822faf3a3ee8fc6ac42a1299" => :high_sierra
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
