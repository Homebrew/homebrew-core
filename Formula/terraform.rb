class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v1.1.7.tar.gz"
  sha256 "7651b69a2196de4393195cef4a03171c83aa50581f1019bca3f17cf05db5335b"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/terraform/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6845abcea8eded72418c0004d118a10fef478874cebf046ee2c4bb0dcd1c4a7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b037696d123dc28e466dcc1f6dcb6164e393a4e6e83a6fed76d20faced63bd6b"
    sha256 cellar: :any_skip_relocation, monterey:       "b9c5a57e44b530ae31a5018594b4b5d6d0968d70c387d2cd2706f0cc3ff3cd07"
    sha256 cellar: :any_skip_relocation, big_sur:        "ef663c8eabfee5dca1c8712456805d59d555155c904d0e7db06d4a3a2eec4520"
    sha256 cellar: :any_skip_relocation, catalina:       "60e94eb1b233f1df90403bb2c8207489a61fd524223262cb6b63e14fe6385c1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cce4a852a7e35687159c7bb5e2ad61cc6fa03b674b44ddfb2ec936f9e4d8025d"
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
