class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v1.5.0.tar.gz"
  sha256 "c53c97dcaa4bf705a3755aa552581c20f525d8204e41b704a0aa9d8890603469"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/terraform/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "89e94e020493b72145358d342add464e30bc177bb235b49b8d0b84abeec28359"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89e94e020493b72145358d342add464e30bc177bb235b49b8d0b84abeec28359"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "89e94e020493b72145358d342add464e30bc177bb235b49b8d0b84abeec28359"
    sha256 cellar: :any_skip_relocation, ventura:        "c29d1d26b17e7e51d89d0d7b3cfd21c35dd4636aba9527b8459e02566a38347c"
    sha256 cellar: :any_skip_relocation, monterey:       "c29d1d26b17e7e51d89d0d7b3cfd21c35dd4636aba9527b8459e02566a38347c"
    sha256 cellar: :any_skip_relocation, big_sur:        "c29d1d26b17e7e51d89d0d7b3cfd21c35dd4636aba9527b8459e02566a38347c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "787c8dc236fd67ed7b8318bb11c9ce9aeb4204285f87161a82c21210f9e928eb"
  end

  depends_on "go" => :build

  conflicts_with "tfenv", because: "tfenv symlinks terraform binaries"

  # Needs libraries at runtime:
  # /usr/lib/x86_64-linux-gnu/libstdc++.so.6: version `GLIBCXX_3.4.29' not found (required by node)
  fails_with gcc: "5"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
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
