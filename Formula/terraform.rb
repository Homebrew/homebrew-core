class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v1.4.0.tar.gz"
  sha256 "1bcab87807eea8290bdd059ef7403ff98bafcd4a052e86251f3ace19a86a877b"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/terraform/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "981152529294c111d8e9374e2bbe8d9cf330dedae306005d69dfc72f6652e3b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be0f11caec4c8b00aa5fab878a3656ecc8c67177ce3ea8570eee0198983fa05e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5715ffb9afd2256fd75dd35e05335bf770bc8697f5bbc6973c21c7a10c0d90dc"
    sha256 cellar: :any_skip_relocation, ventura:        "e60a6bdff7e63d995729ddd2162ce55f3b4064e4f540181f2ac2355ee0ca77c2"
    sha256 cellar: :any_skip_relocation, monterey:       "109cd562e856890f51e250d3dce76d0b0991c76047db8b092821f3806953ed5c"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb5ad5ce90982eeb4f4adf983b5b413ac2245e82599527000bd43818064b4d94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "472fb3d3d1c245f395184b45ec2640ec9052c72fe5bf838cd70fd6beaf4b483e"
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
