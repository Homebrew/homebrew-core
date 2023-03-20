class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v1.4.2.tar.gz"
  sha256 "bbdd764589fc9273bcef50c35274738ca1016e8bb47dbd8180781b61eb8e9315"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/terraform/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68beb682a0448b44cec5101fb9a2800f1cc6be86959e7b645a47afbb859b8aab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68beb682a0448b44cec5101fb9a2800f1cc6be86959e7b645a47afbb859b8aab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "68beb682a0448b44cec5101fb9a2800f1cc6be86959e7b645a47afbb859b8aab"
    sha256 cellar: :any_skip_relocation, ventura:        "9e7e0d1c80c251f2b418d4b31179f1723076ac2ccca61bf882bd84bcb648e76b"
    sha256 cellar: :any_skip_relocation, monterey:       "9e7e0d1c80c251f2b418d4b31179f1723076ac2ccca61bf882bd84bcb648e76b"
    sha256 cellar: :any_skip_relocation, big_sur:        "9e7e0d1c80c251f2b418d4b31179f1723076ac2ccca61bf882bd84bcb648e76b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6db72ebf065329d56912232ff863c199fbf44af655145e05f86d1db7ceea5210"
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
