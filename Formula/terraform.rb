class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v1.2.2.tar.gz"
  sha256 "c9e4973dd91b8d0d0f8b8a7a5a2cdf556a2629b24660030a70e7e76b305f016e"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/terraform/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c2f2c1197d1e312942a72aa39091f9ee0b303764f15a9398c9a17310fe9e987"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "46066ef6a8209e178866769c5251038782195100b5da69d91d8ce679952f556b"
    sha256 cellar: :any_skip_relocation, monterey:       "d04484e87ad212566880938f86d3fc6c927b6d144d054f6249c3b039ef11c6f8"
    sha256 cellar: :any_skip_relocation, big_sur:        "5f030ceec9590ffa3517978a6edd9ca9f07cf66e77a85f6d57396bd617014acc"
    sha256 cellar: :any_skip_relocation, catalina:       "0d27d0e01b8e4909013da11a6275da75e1d9834e5ef39ae4b173c5773ee3e7ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "906b366df5e5a950e7a1b19b9ae045da7079c93727a03372d35e948432dc6d78"
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
