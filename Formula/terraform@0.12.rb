class TerraformAT012 < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v0.12.31.tar.gz"
  sha256 "f53aef1f1ea9d72a30145f0018cc16fea076ae09bd93faa320645af7bce3bf4d"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c1e4da55fb02c5f9ee2c0bbceb32927b7396ae759fe418ace857afc1346c226"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "46b7341d0710f40ec6532bf16de55226e1df553408e99a97dce9aaa668efac27"
    sha256 cellar: :any_skip_relocation, monterey:       "21aa5de3857889453b4ec7ed810df350b22838cda61baa7e6db6a0c3946d5891"
    sha256 cellar: :any_skip_relocation, big_sur:        "bcbadc631d4a94c210c5d2b7a82120dee050f6263abc8d2cda78eb5ad0c2cfc5"
    sha256 cellar: :any_skip_relocation, catalina:       "bcbadc631d4a94c210c5d2b7a82120dee050f6263abc8d2cda78eb5ad0c2cfc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75fd648fb8fd2dcb7e922d7ca2f5ca8c044c4967c625144a758e05368b4ace1c"
  end

  keg_only :versioned_formula

  disable! date: "2022-07-31", because: :unsupported

  depends_on "go" => :build
  depends_on macos: :catalina

  def install
    # v0.6.12 - source contains tests which fail if these environment variables are set locally.
    ENV.delete "AWS_ACCESS_KEY"
    ENV.delete "AWS_SECRET_KEY"

    ENV["CGO_ENABLED"] = "0"
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
