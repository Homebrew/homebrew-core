class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v1.0.2.tar.gz"
  sha256 "036a028cb311c001c48e86bc65e9b7870c81de57e96437325247785cf6c84937"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/terraform/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8d1640e8d95cab2c3889e0acce33aa57f0d66f11aa37139d7e60b3ec4a22b281"
    sha256 cellar: :any_skip_relocation, big_sur:       "4cf97326be462d59d3e4f0511e1d5bf65f1adac15709a0bed05607241335b629"
    sha256 cellar: :any_skip_relocation, catalina:      "4a8950a791124e0902bc94c58d4d1238962cc434970b6de2744e75aca776a2e8"
    sha256 cellar: :any_skip_relocation, mojave:        "cde83d21d5779df8387b344b507108fbd96d0b5b2a13bb90558e373cf58fbda6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3cb25342e90a4a20d3d822d8812035bbc096f44c9e4f563b8037f8038f463fb"
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
