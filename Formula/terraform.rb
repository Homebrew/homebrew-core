class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v0.12.28.tar.gz"
  sha256 "8381058d49ce3804efc72c2afdc4691194418e0da61b8a553fb1c0e81e0c2087"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "33bccc922a2204ce317e553dcc6cfc2106cd8ff72c9e12ada102100741c5242d" => :catalina
    sha256 "bc46af39ad947e0ae428ef8605f8cf38e55330860423440ae8dee147d363bdcc" => :mojave
    sha256 "c1ea4d4491aded438793b5857a81fc1557de4d6d3117029b2fd7a9a0af7ca3d1" => :high_sierra
  end

  depends_on "go@1.13" => :build

  conflicts_with "tfenv", :because => "tfenv symlinks terraform binaries"

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
