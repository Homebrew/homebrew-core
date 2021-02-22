class TerraformDocs < Formula
  desc "Tool to generate documentation from Terraform modules"
  homepage "https://github.com/terraform-docs/terraform-docs"
  url "https://github.com/terraform-docs/terraform-docs/archive/v0.11.2.tar.gz"
  sha256 "0f409934c2e1a57bcebb5f3b2f4bd44c31981f55e861413924bd2605a03f4c5c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "917f8e86e2565282dadaf4157ad213ff37ec94dac73892a503aad8ae4dec5c8d"
    sha256 cellar: :any_skip_relocation, big_sur:       "f4198f2b3bb9db1facedc7e9e8f668a6433a5e66875f5a3933d41aa9a8dd1c77"
    sha256 cellar: :any_skip_relocation, catalina:      "633a334f642b1fa759755a0b7120e41efab924a34b09016f846fda5a31afbf1f"
    sha256 cellar: :any_skip_relocation, mojave:        "63fde1b2bab27e794e1c8e61a85d6346e80da900a6867a3d387dc0d74d044be3"
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
