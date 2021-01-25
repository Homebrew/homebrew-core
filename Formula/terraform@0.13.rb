class TerraformAT013 < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v0.13.6.tar.gz"
  sha256 "a057c041c8b282c02b2cddb2e301c0c5165db37d6305c3fe187e6b357c542d2d"
  license "MPL-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "2be4e09894ddede7b099ffd95450425ee87f34d7430ea294ed21e6777601c9b4" => :big_sur
    sha256 "687e490a5e0d953b4007ed234a81327878da1b31eb33f9f74f2164b189249c1a" => :catalina
    sha256 "b14780d63a50d9e82ce1401cc487f1385251ebd6467a46525cb122cfd532c531" => :mojave
  end

  keg_only :versioned_formula

  depends_on "go@1.14" => :build

  def install
    # v0.6.12 - source contains tests which fail if these environment variables are set locally.
    ENV.delete "AWS_ACCESS_KEY"
    ENV.delete "AWS_SECRET_KEY"

    # resolves issues fetching providers while on a VPN that uses /etc/resolv.conf
    # https://github.com/hashicorp/terraform/issues/26532#issuecomment-720570774
    ENV["CGO_ENABLED"] = "1"

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
