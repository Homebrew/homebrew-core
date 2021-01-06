class TerraformAT012 < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v0.12.30.tar.gz"
  sha256 "09db85a429ade5cc43cf49a3e19a921093a7e3c97073732019a9dd7634e0de9d"
  license "MPL-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "f51cd1a653fa830f6bb199b1fb24a91c980262ee19d08e1ba68c8bec2c54e129" => :big_sur
    sha256 "6dd856617186380d96a3b277e6df15f9df0a929c44c1567e70cc1cff8fcc58e3" => :catalina
    sha256 "6dd856617186380d96a3b277e6df15f9df0a929c44c1567e70cc1cff8fcc58e3" => :mojave
    sha256 "6dd856617186380d96a3b277e6df15f9df0a929c44c1567e70cc1cff8fcc58e3" => :high_sierra
  end

  keg_only :versioned_formula

  depends_on "go@1.13" => :build

  def install
    # v0.6.12 - source contains tests which fail if these environment variables are set locally.
    ENV.delete "AWS_ACCESS_KEY"
    ENV.delete "AWS_SECRET_KEY"

    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args,
      "-ldflags", "-s -w", "-mod=vendor", "-o", bin/"terraform"
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
