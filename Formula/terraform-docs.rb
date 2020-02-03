class TerraformDocs < Formula
  desc "Tool to generate documentation from Terraform modules"
  homepage "https://github.com/segmentio/terraform-docs"
  url "https://github.com/segmentio/terraform-docs/archive/v0.8.2.tar.gz"
  sha256 "005957c5c5d56a27e60ca735128231f68c3f099b433a7041a0f1591bee59fbd0"

  bottle do
    cellar :any_skip_relocation
    sha256 "7fc6ded7ab5178a43d619879843e3bfe5540660a545dec2a8e0ba632d99e9982" => :catalina
    sha256 "646206a2c589953f550ea21f150bfa7465790585b1b8790929c33253131afe5b" => :mojave
    sha256 "81a0e5738acbe5160c8fd33759e4e245f8efdd707f28c2c67ac1e498caa7d9bc" => :high_sierra
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
