class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v0.13.0.tar.gz"
  sha256 "b531255bd4e1dbbc7fc5e01729b77f8781cc0f369833d01211048f0667e56cee"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f7c787a4c42bb1291200f19b112aae5f725fc0fad068ad2422003e73ab74e4f7" => :catalina
    sha256 "f7c787a4c42bb1291200f19b112aae5f725fc0fad068ad2422003e73ab74e4f7" => :mojave
    sha256 "f7c787a4c42bb1291200f19b112aae5f725fc0fad068ad2422003e73ab74e4f7" => :high_sierra
  end

  depends_on "go@1.13" => :build

  conflicts_with "tfenv", because: "tfenv symlinks terraform binaries"

  def install
    # v0.6.12 - source contains tests which fail if these environment variables are set locally.
    ENV.delete "AWS_ACCESS_KEY"
    ENV.delete "AWS_SECRET_KEY"

    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args, "-ldflags", "-s -w", "-mod=vendor"
  end

  test do
    minimal = testpath/"minimal.tf"
    minimal.write <<~EOS
      variable "aws_region" {
        default = "us-west-2"
      }

      variable "aws_amis" {
        default = {
          eu-west-1 = "ami-b1cf19c6"
          us-east-1 = "ami-de7ab6b6"
          us-west-1 = "ami-3f75767a"
          us-west-2 = "ami-21f78e11"
        }
      }

      # Specify the provider and access details
      provider "aws" {
        access_key = "this_is_a_fake_access"
        secret_key = "this_is_a_fake_secret"
        region     = var.aws_region
      }

      resource "aws_instance" "web" {
        instance_type = "m1.small"
        ami           = var.aws_amis[var.aws_region]
        count         = 4
      }
    EOS
    system "#{bin}/terraform", "init"
    system "#{bin}/terraform", "graph"
  end
end
