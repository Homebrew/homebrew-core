class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v1.0.3.tar.gz"
  sha256 "0b746b3464aeee13bfca8872123574be56309207920347b6e00f665ff4c8b402"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/terraform/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "21124f9183cc412db43f260fe21180b785aea099eef6744d0c95ecb3665beb6e"
    sha256 cellar: :any_skip_relocation, big_sur:       "fc3c635772ddc322986c1c87c3204145874a0058b365116dcc921d64e4c3cbdb"
    sha256 cellar: :any_skip_relocation, catalina:      "f9a8260f1d7fa0b32cec11e120d5ae4a466c41b04d05a0ff5a0da02c0f218755"
    sha256 cellar: :any_skip_relocation, mojave:        "d9cdd42b6bb80ac80f0105b48fdc4556355c30e8c1d3ce51a706fba76e4a1deb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88e75bee2d33d7997e629d69cf6aca6292431c1075b1610ea3e876cd966ee34d"
  end

  depends_on "go" => :build

  conflicts_with "tfenv", because: "tfenv symlinks terraform binaries"

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
