class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v1.4.5.tar.gz"
  sha256 "65c2ec58448fe22a72288430d44d3269db040f3c191500d35bd065e863b3bad7"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/terraform/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e601b84d2045b120b5af86b93b2902139bf5ab891ca536e7153f822c792759ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e601b84d2045b120b5af86b93b2902139bf5ab891ca536e7153f822c792759ed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e601b84d2045b120b5af86b93b2902139bf5ab891ca536e7153f822c792759ed"
    sha256 cellar: :any_skip_relocation, ventura:        "538abc8bcc18096890d7e187e756eddc4b50b7f0728b3894adc1385063722f5d"
    sha256 cellar: :any_skip_relocation, monterey:       "538abc8bcc18096890d7e187e756eddc4b50b7f0728b3894adc1385063722f5d"
    sha256 cellar: :any_skip_relocation, big_sur:        "538abc8bcc18096890d7e187e756eddc4b50b7f0728b3894adc1385063722f5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3de71d3eb7bf6a10b7156a68a27978919293617b3d4751a69f0dfe1c32822ce"
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
