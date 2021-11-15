class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v1.0.11.tar.gz"
  sha256 "c86040599f81202bb09b9f3fc637fdf4fe95cd9dbd6c3b41b366e2cdc5d908dc"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/terraform/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e23c09f8bdf189f3f76f12ed80712ca94866a39bdb9b99c5e7820ac30b76dee4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "40dc040ec699a77a3ce335f9454e4390073c6c49b24d11a694cdbd2da99f8525"
    sha256 cellar: :any_skip_relocation, monterey:       "983fd4af4ed0105d5735dd726c9a5826f775d79f84143a254b74ffb17931b1fb"
    sha256 cellar: :any_skip_relocation, big_sur:        "0b15e020b9a6bf06aec079ecbe939e810710a15f3a785a4c3b8879c2a831243e"
    sha256 cellar: :any_skip_relocation, catalina:       "8dc70f908930d0c1a9edccd1e05447867681c0981c39673ede15cf6607b09fe4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c71d0ce5c031d720711a0be777c7c0af6ae665fdfa31f98ba7b181f42105c797"
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
