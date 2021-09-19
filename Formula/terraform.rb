class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v1.0.7.tar.gz"
  sha256 "76c343637517df13abe5e25ad55057b3c2a85604591d37cf5b29685083a0de43"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/terraform/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6157896dce234a226e294353bf7c4a66230977d0d2720f5152cdb3207b522c72"
    sha256 cellar: :any_skip_relocation, big_sur:       "df5489b52be0a74cb2d6602593678acd0150861dca6755ead2e1623327500348"
    sha256 cellar: :any_skip_relocation, catalina:      "89c905302b81b74931aa85ed7ef1765ade632b88983786ae8ebd2aa3a30e8440"
    sha256 cellar: :any_skip_relocation, mojave:        "1f2694f09019a2e61fd03debf56d692bb17cd18067943311efc700085d48b823"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c1591c9de3d8da747f2d4deaa94d9fba8f214aea532c43ad536aa8e525a2da3"
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
