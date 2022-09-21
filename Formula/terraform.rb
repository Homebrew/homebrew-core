class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v1.3.0.tar.gz"
  sha256 "97695ddad24563a2f9a1de868ae4fdee4a8b54e5e43e9e374031a90228c48576"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/terraform/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "483a95ad0107cffbbd56d75ee9039f8f81b6f805f6c7b78ff687878a0987185b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "07ea3c933beffa10cd07d88b687a909da2cc2f53284ab94bab0f15515168414e"
    sha256 cellar: :any_skip_relocation, monterey:       "f10e7dfd1e76479fe7d568308349bed8f61dd97ea4b54f1c775e2625d95a29cc"
    sha256 cellar: :any_skip_relocation, big_sur:        "3aa44b2d6b73f6aefe38bd7b18f3c954218d8c227eb30706a8b530817f96cc17"
    sha256 cellar: :any_skip_relocation, catalina:       "86bafa862d741f18caea29a4e44a205c2212bd912a082239e92348316bc28280"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "346db9dd674f6d4ebe783b5bb32364834ae2ebd991e523d745ed3eaf56fde1ac"
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
