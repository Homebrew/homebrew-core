class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v1.2.7.tar.gz"
  sha256 "8d5695071ca0e59e7b52a717734a0f65f7853183b56df776a165fa0d56f417d1"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/terraform/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e540a9b52663354b837af2e52ab6e6997d695f21fccb1fbdc84112f6f7bca301"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3f9e77cc1242a73ae560310f510da38289892dee322c3161a319b1b016716a33"
    sha256 cellar: :any_skip_relocation, monterey:       "fee7d9aa2dec048298d529ce53e5ef776adaeff2b183d60bf45f60550d85626b"
    sha256 cellar: :any_skip_relocation, big_sur:        "382f5942bd05544d43298f71da463476aba0414732e6a0fb1bda9f1f42a5f57c"
    sha256 cellar: :any_skip_relocation, catalina:       "42a7245aaf6c510ec68972bee94f54e7b495f9d074839ff8c5d98ae5ff36d210"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4af7fd31508f89b3d8bc6bc3becf62cef4e24a6326a44ce9c62b13832dd5ef7f"
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
