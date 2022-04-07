class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v1.1.8.tar.gz"
  sha256 "2d2f2dcb5e438ef4587c2a1476646d19c7d69e6e6c86112d05dce8d780da8d79"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/terraform/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00f036443d245b6156e7ac7220fb57c15445269df3fb8be2ac5eee61a729231b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "11385c6e3222c0b461d2a0e2e8ddbb4df453460d3eae41e0594812da3e8aeba9"
    sha256 cellar: :any_skip_relocation, monterey:       "62beb0d37a03ce90c338e8f44eb93bfde88e0532e761cc5d8a42ea90fdb32b2a"
    sha256 cellar: :any_skip_relocation, big_sur:        "c568345d52c524e160df863264c6e0d2970b2b2854d9a3e0b27d46cb365418cc"
    sha256 cellar: :any_skip_relocation, catalina:       "03b6132cecb0105d88fb102a935bc7aba85b3ab6a9d175c06c7cab0741f929e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38cab7780d4b5ab92dcb0066f238f42ca3d32eb5af827e285ef0d739310121d1"
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
