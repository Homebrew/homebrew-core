class TerraformDocs < Formula
  desc "Tool to generate documentation from Terraform modules"
  homepage "https://github.com/terraform-docs/terraform-docs"
  url "https://github.com/terraform-docs/terraform-docs/archive/v0.10.1.tar.gz"
  sha256 "f3cc429d8edd129c73ca18feafd17bf1aacb0397b3653b7f65aa3978c4d6c337"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "b4e60a1c75bdaf1ede49d26eab11db036a22282a1580ec0d34c2eb323b74dd6d" => :big_sur
    sha256 "9af166d0e3af3d696770e94b819739e97efdedb623a07f2bc1fb3f0698760b44" => :catalina
    sha256 "219f33fc44d5c4d032997fae412694f510ab62a33eb9816d387e1c24d8717605" => :mojave
    sha256 "2544851eb87efa344c48392c85404f82c3ef9c5a868555f743cf12f45c860b48" => :high_sierra
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
