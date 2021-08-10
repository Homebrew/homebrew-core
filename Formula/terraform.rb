class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v1.0.4.tar.gz"
  sha256 "71a9d9e4a5d3ccfc6c41710a48870259ac977a2080f4d734a4b8fb8dc18728b6"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/terraform/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b8e5da1aebd83f1afcd7e51b7e6d2f421d7e2be77e24ce164b066fbb959024b9"
    sha256 cellar: :any_skip_relocation, big_sur:       "e10b91ecf7df1ceaa3b3cb543408cc825a03ea358ec94b1999f279fb6664bbcc"
    sha256 cellar: :any_skip_relocation, catalina:      "d7dd8de08a632725c5aaa2a8a2e8d3b3adb9bf474639ae082f01414c87eee694"
    sha256 cellar: :any_skip_relocation, mojave:        "9f3b8c36ece942718bbff7f99559799a2fe98e47b653e3bea58cb404f7cabec3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44f1c51dbc5657e50f670843662ab6e87aa50ce4647f74e2d259d186b1dc5276"
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
