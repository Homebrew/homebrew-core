class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v0.14.10.tar.gz"
  sha256 "509f182f2e4d100ce99660ed6be0710b4f8e7926c83cef87852e13b3b34e7f23"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform.git"

  livecheck do
    url "https://releases.hashicorp.com/terraform/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9fa4f41a5a7e06d333360a115aa9522c7c9bf2af1d084c1fda97afe5bb42b6b5"
    sha256 cellar: :any_skip_relocation, big_sur:       "dfd5c5743fdc5673306af64c8e0e90f772cbba9894c8dfd9e5db997d78701c51"
    sha256 cellar: :any_skip_relocation, catalina:      "13569fb0d2ca22be30ba47cd1b174d991fb2066a76b66f63d5fee7cad0c3adcc"
    sha256 cellar: :any_skip_relocation, mojave:        "bfee3798e84bbb0015f294643e1cba328dac8584501610c948d65f46cba83b32"
  end

  depends_on "go" => :build

  conflicts_with "tfenv", because: "tfenv symlinks terraform binaries"

  def install
    # v0.6.12 - source contains tests which fail if these environment variables are set locally.
    ENV.delete "AWS_ACCESS_KEY"
    ENV.delete "AWS_SECRET_KEY"

    # resolves issues fetching providers while on a VPN that uses /etc/resolv.conf
    # https://github.com/hashicorp/terraform/issues/26532#issuecomment-720570774
    ENV["CGO_ENABLED"] = "1"

    system "go", "build", *std_go_args, "-ldflags", "-s -w"
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
