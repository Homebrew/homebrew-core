class TerraformDocs < Formula
  desc "Tool to generate documentation from Terraform modules"
  homepage "https://github.com/terraform-docs/terraform-docs"
  url "https://github.com/terraform-docs/terraform-docs/archive/v0.11.1.tar.gz"
  sha256 "33d68359e7311322a4c560570c003498479496e3ccec9de88a68734cd67b592c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d2de8b3659365d7c1663b4ef794c1ddd22a59b34715b5b5db995143b2c718966"
    sha256 cellar: :any_skip_relocation, big_sur:       "6af708a1ca447a7e7c0b6b8a5039eb8eef0f3510447c80f7ad170f0ea7c0104f"
    sha256 cellar: :any_skip_relocation, catalina:      "4a2f93e8f3c9b4670359701f74a87635425a97ff327b094f1afebbdfb4e7e13b"
    sha256 cellar: :any_skip_relocation, mojave:        "c8b53434c5e58b2c7a17df585c27377e9f1909a8013a5b1841db2386c1a7a3ad"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    cpu = Hardware::CPU.arm? ? "arm64" : "amd64"
    bin.install "bin/darwin-#{cpu}/terraform-docs"
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
