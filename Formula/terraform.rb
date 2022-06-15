class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v1.2.3.tar.gz"
  sha256 "0bc726b85e0ef7325f9cc525f6e57cba46ed24e23f7d7d3d0ed3df91811a4ac6"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/terraform/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3d293dc4f85416f085d4bb87a480d7de73016f3b0f2a1368baef4f282e5f8ff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a2a0072507f5096fb282c8ad7378c3264a8b052cd8df3e4b4e6f013d1b5539bb"
    sha256 cellar: :any_skip_relocation, monterey:       "76d145b91d940fe718654ba432c8ce724825b24996c67eab89a85ba352d51376"
    sha256 cellar: :any_skip_relocation, big_sur:        "9c64e04f3e27493263163a87fb3f1bab4c173535a76c7fd35228663f0eecc154"
    sha256 cellar: :any_skip_relocation, catalina:       "3135f3151bf6c2c5a7c6de5a8f1931ddb38e67f6ce20dc635f80891359de705c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f28437cce506e09880a29d09f61da6a5bc9e75a031e2ac1f1c1a2936e60e6cce"
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
