class TerraformAT013 < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v0.13.6.tar.gz"
  sha256 "a057c041c8b282c02b2cddb2e301c0c5165db37d6305c3fe187e6b357c542d2d"
  license "MPL-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "0ec5412c1760c74a03116027f695c59c174a43ca443e1dbbfcfc74d444f0d02d" => :big_sur
    sha256 "2eb194afe33fccd297800339ddc7ab46c536ad65d15b3149941d12c17e8388c8" => :catalina
    sha256 "ba1565728f8ad9627b1ec549eb6ef1793699ba6bb5b4e9191467de1b5ab8f82e" => :mojave
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
