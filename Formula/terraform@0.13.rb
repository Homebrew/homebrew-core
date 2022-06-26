class TerraformAT013 < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v0.13.7.tar.gz"
  sha256 "7395800a4523d4a1483f96d71636c2710a7e9de19c37cc0f03fdb51414a63cf0"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "a9071c87b749036c6b9b0287af782e80e0282e7428718355ae8a2cea2c70bdb6"
    sha256 cellar: :any_skip_relocation, catalina:     "59fb34b8e85bbfc049a2e2950539abab123904d101bf572c85cd963e901ed1a6"
    sha256 cellar: :any_skip_relocation, mojave:       "ad5aad95ca700df4f9c61ec68734952e6a72b223a7cf2762eb7aa3b03b6c7b69"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4f7a689aa70f30e171b26de7bc1ef214f1ddb9c60950865c1530833f99e609a8"
  end

  keg_only :versioned_formula

  deprecate! date: "2021-04-14", because: :unsupported

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
