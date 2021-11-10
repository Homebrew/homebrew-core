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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c3419217a5734cb5fcbb167d0a7033728a7691dd01d3e39fbb56a7e499e9d08"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d025e9774d6306280681cb08d49313eef3ae907d7045e38a2835808c04db085c"
    sha256 cellar: :any_skip_relocation, monterey:       "6e02f20207e0eec73f272e9f6c9fb407dc169b49b24d8cf55048b6a2ffb95631"
    sha256 cellar: :any_skip_relocation, big_sur:        "143dad242e5a8c4eb2ff594cb342cf3919b270959f95eceb65a5702cf4b846b7"
    sha256 cellar: :any_skip_relocation, catalina:       "db9d95012cd318756cd726b1e0cbf8af1ec3bd8d72eda496dd6f46a473f4ccd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1369444bb80e9510d67e27c2e0301df920f098d7f0b5b515227a60db083a5d56"
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
