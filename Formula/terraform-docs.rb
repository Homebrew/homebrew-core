class TerraformDocs < Formula
  desc "Tool to generate documentation from Terraform modules"
  homepage "https://github.com/terraform-docs/terraform-docs"
  url "https://github.com/terraform-docs/terraform-docs/archive/v0.11.2.tar.gz"
  sha256 "0f409934c2e1a57bcebb5f3b2f4bd44c31981f55e861413924bd2605a03f4c5c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "397b1e57c3f486b715067a4d033d1d4aed1a4087fd9125e640eb172fa9a911da"
    sha256 cellar: :any_skip_relocation, big_sur:       "217078eb92ae040da5e32a587cf06f78390ce575a467bed0381748128c55a298"
    sha256 cellar: :any_skip_relocation, catalina:      "2d461a60cca9cd8c10ca1b596b210cdaf2a5e4d9b808cff2cfedf262185d5457"
    sha256 cellar: :any_skip_relocation, mojave:        "dbfa96439adb5d07f9b7e18b4ecd8d32c66d3c24e55500de086483ed2f3f9033"
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
