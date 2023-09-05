class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  # NOTE: Do not bump to v1.6.0+ as license changed to BUSL-1.1
  # https://github.com/hashicorp/terraform/pull/33661
  # https://github.com/hashicorp/terraform/pull/33697
  url "https://github.com/hashicorp/terraform/archive/v1.5.6.tar.gz"
  sha256 "b5866bf9c7efef74e1f6f2a7ba0a39e645ce77f5dfeb4faebb38e8e7d21476f1"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/terraform/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "84e4c20defa7fb567b4b2c4542814131a73faca1f9dc5742f3eca3373fe12868"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be75264e34c08bcd32cf638283b1c4f379ad5c747fcd228b6850baf34c65ac77"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "58918cf6df857483d61ad23c9612b8cf0fe6a850d08032d1e8b675b88713272b"
    sha256 cellar: :any_skip_relocation, ventura:        "cef2c017a8985b23bf6bc5cd6db4e5a53ddbd23cdaf8c2e8595f0335b39a119f"
    sha256 cellar: :any_skip_relocation, monterey:       "2abd765acd70c1714bfbfba7c3e52c9a606a1a970a25a3627ef6e308f6189ce8"
    sha256 cellar: :any_skip_relocation, big_sur:        "285aed8fca6988d68cce062a82c8e18361c6cfccb4edaf5c07f2ecd62e09d445"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "207dbcfecdb3c96b45658df0a2a22cb6f8a1c1b3975303fdefefb45b2a48249b"
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
