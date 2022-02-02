class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v1.1.5.tar.gz"
  sha256 "9c8de6905cb70aecd76a659e915bad7f2f7aa4dc3da0b8aea681b62885381a2f"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/terraform/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc5050536649400e4ee12293b1ef62cd29c6f92e632dac28dc47e33eb2eb4c5b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c944f2fffd657e2bf805c6a44dde3395823d3fcac95240283e23365174aa5d07"
    sha256 cellar: :any_skip_relocation, monterey:       "a9272f338335078076d13f6593f308713892c99d2ff1bea4e3a78c5bbe55fde2"
    sha256 cellar: :any_skip_relocation, big_sur:        "5fd1a55b43110879597e9de48893b00d68d7145e25b68fd9eaaff6d07d422dae"
    sha256 cellar: :any_skip_relocation, catalina:       "6b061032daa9a52216c03f2927ef10e51871dd27afa6fd909f6a7fe8d7daea2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7796f4409c630912ab26737c6c0add2054e4de247a726b41ec520541fc6cc2f0"
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
