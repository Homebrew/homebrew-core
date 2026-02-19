class TerraformDocs < Formula
  desc "Tool to generate documentation from Terraform modules"
  homepage "https://terraform-docs.io/"
  url "https://github.com/terraform-docs/terraform-docs/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "e8180d74662707b2643930aee7ba012a29ad767ef55fd3321d6a9f3ce7fa79b8"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e0d3dc055f2dec3731d78b46495b133ff703f1552380f32020ab8efcc59f6f82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d35e1bb260d8ec2fd27135ffddaa6d59a41b7fba788c99f4fdd9f7f9157b82b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "efbfbfdbad330848c4b3e1f7165765aed9616a65a438fb90de41af9243f97eda"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1b1e387eb27ef167275c66f73dc3019c082777c333ef8c03f93372594394c7f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "728494fc61676afd9396d470988588a9961c4609820bb2028194864f37f2ed1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef78dd170f5f0e90ab3b71116d50949545fb6b5c7de883749f9f9fc151f2c3ac"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    cpu = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    os = OS.kernel_name.downcase

    bin.install "bin/#{os}-#{cpu}/terraform-docs"

    generate_completions_from_executable(bin/"terraform-docs", "completion")
  end

  test do
    (testpath/"main.tf").write <<~HCL
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
    HCL
    system bin/"terraform-docs", "json", testpath
  end
end
