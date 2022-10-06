class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v1.3.2.tar.gz"
  sha256 "51c41c40bcd87b917046b786cf6d32d3b2b5f6c5fc4cb84121944efc9be54cc0"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/terraform/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f7fd4bbea5476c20e9f3a85cce4ea3763ae4764e4b0f9567b44919e5b332f4e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa1ce82f6423c82e101de90061333577e2d55964f4f69b6d73410a149542b7ba"
    sha256 cellar: :any_skip_relocation, monterey:       "16bd4fba33097131e2596220a0f1ac5a1f35992518c4e00c93cdfd86ac6650dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "6ff3955525c7092d3b94b8a7c6398c1b88c3b5e3d3c5e59a60ebe426d2ffdc05"
    sha256 cellar: :any_skip_relocation, catalina:       "fade5766aae582e44ca706d843ae3553ed41a91858f60eec28977ead3f5959e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b6672b6b760bda9c347648499e87372e5736e2f350e7fd01572fc5e517b0137"
  end

  depends_on "go" => :build

  conflicts_with "tfenv", because: "tfenv symlinks terraform binaries"

  # Needs libraries at runtime:
  # /usr/lib/x86_64-linux-gnu/libstdc++.so.6: version `GLIBCXX_3.4.29' not found (required by node)
  fails_with gcc: "5"

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
