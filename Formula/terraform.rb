class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v1.4.1.tar.gz"
  sha256 "338a6d1f13d27c8c5666d0b91649e2a923cc1204a8d33cb29a126cc8a7bd064d"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/terraform/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b9e5236ffda6b65ea8a4cdc6f2852f27b02f9d6c2f0225a80acb502b456297ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9e5236ffda6b65ea8a4cdc6f2852f27b02f9d6c2f0225a80acb502b456297ee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b9e5236ffda6b65ea8a4cdc6f2852f27b02f9d6c2f0225a80acb502b456297ee"
    sha256 cellar: :any_skip_relocation, ventura:        "1d904ed9316d7e4916d00b94b1305674b9e662e07df946b207bd6771bffc978f"
    sha256 cellar: :any_skip_relocation, monterey:       "1d904ed9316d7e4916d00b94b1305674b9e662e07df946b207bd6771bffc978f"
    sha256 cellar: :any_skip_relocation, big_sur:        "1d904ed9316d7e4916d00b94b1305674b9e662e07df946b207bd6771bffc978f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba5dcda4f1fdc5eec5bd17403c776a4e9390ad065e1b84399e92ae8d20288aee"
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
