class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v1.0.9.tar.gz"
  sha256 "ac9b23a51d900169461c0360a3191440ca0d565714721ec08a0fedc0addf97e8"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/terraform/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ac4219fdf70546e9412eaab738446630e2e84a04da72b1b86aecc7f4d0eb4319"
    sha256 cellar: :any_skip_relocation, big_sur:       "e88c4f7892d63ac2b422d9efbd9b37f3126f9449ad5fbcead959e4223e14464c"
    sha256 cellar: :any_skip_relocation, catalina:      "d10c56f76b0eefd04916c832b89af79c2d7ca5bdb942ffd73887c665f7248f2e"
    sha256 cellar: :any_skip_relocation, mojave:        "4c937d477b5b622d162c14a1d9b91e2e8eee2cf182b4627d71138be7aa629a6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f0d2a38b0b567938c8e21528059ec0dbbd36bb14276c5cd98da74bae7c38eb7"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "gcc"
  end

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
