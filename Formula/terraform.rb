class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v1.3.9.tar.gz"
  sha256 "243fcc54910a41b58a1c7a9be1d0f875100a68f51fb64fbe499d9003c44fbf73"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/terraform/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d43cea89c561535b23517dd47fe6efe065e5fe4f9a6c9ee01eb3007cfdc96f9e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "626c3c8c3e97730b2c552714b353d7f39f13ad10a6006dae65ba0b4c37d78c41"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ec1d37871df2b10c5cc9a88a4a26624d67014a0b098ba6bd5d708db83c015e8c"
    sha256 cellar: :any_skip_relocation, ventura:        "20496a0b403a6f2d02494a8f30d4fbd62ad2796e1aa5d1a1aa528eb8e84dfe01"
    sha256 cellar: :any_skip_relocation, monterey:       "4bb2cd98ca9796112cd24fb240940d27f3b5d6fa719f51f585bbbaef4ade5470"
    sha256 cellar: :any_skip_relocation, big_sur:        "a54cbc2371bd748bec435af3c6a5faac168a1f52fea399133f57b6f9cbd231ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2af48b480fb1a09c09ea30bfd8526a2877a5b33634b1ba8897f6f87d70e457f"
  end

  depends_on "go" => :build

  conflicts_with "tfenv", because: "tfenv symlinks terraform binaries"

  # Needs libraries at runtime:
  # /usr/lib/x86_64-linux-gnu/libstdc++.so.6: version `GLIBCXX_3.4.29' not found (required by node)
  fails_with gcc: "5"

  def install
    # v0.6.12 - source contains tests which fail if these environment variables are set locally.
    ENV.delete "AWS_ACCESS_KEY"
    ENV.delete "AWS_SECRET_KEY"

    # resolves issues fetching providers while on a VPN that uses /etc/resolv.conf
    # hashicorp/terraform#26532#issuecomment-720570774 (`brew audit` failure with closed issues)
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
