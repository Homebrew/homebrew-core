class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v0.15.2.tar.gz"
  sha256 "fbc4c0744bf3111029348b5d505a0c0e5e0e4b980cbff2eb8f5f5ca18b531243"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform.git"

  livecheck do
    url "https://releases.hashicorp.com/terraform/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f7eb7c0f8376d29a1b7051ae1d909ab524ba49d7fcba0739dc9ea77678b30526"
    sha256 cellar: :any_skip_relocation, big_sur:       "8fbb13d136b5b918b0ceb327908f83493f7fee54444c552f249fc1d2c2b34490"
    sha256 cellar: :any_skip_relocation, catalina:      "c0e4784ad198c159ee4bce45fc4eae33d9209fc6cd12667fe8e0b9a54b2e3183"
    sha256 cellar: :any_skip_relocation, mojave:        "cb4fabf589aca1d94ca658f8208c4384a55dcf48ca494ee2eb90db0f4f20fe54"
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
