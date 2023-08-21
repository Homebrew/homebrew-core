class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  # NOTE: Do not bump to new release as license changed to BUSL-1.1
  # https://github.com/hashicorp/terraform/pull/33661
  url "https://github.com/hashicorp/terraform/archive/v1.5.5.tar.gz"
  sha256 "06a72b5ecda4e10d5f2a3c7627420cf0ca0a6b7b47ef0ae151cc1c6ef38eb2fe"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/terraform/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "36bab128ce1eadbb70ba7c9e4e3d7dc8920281efc67797ff2390a2d68bd5889e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36bab128ce1eadbb70ba7c9e4e3d7dc8920281efc67797ff2390a2d68bd5889e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "36bab128ce1eadbb70ba7c9e4e3d7dc8920281efc67797ff2390a2d68bd5889e"
    sha256 cellar: :any_skip_relocation, ventura:        "c294eccff528712de05bf1093be22936efe5743107d74d0a64137c2d4ece0254"
    sha256 cellar: :any_skip_relocation, monterey:       "c294eccff528712de05bf1093be22936efe5743107d74d0a64137c2d4ece0254"
    sha256 cellar: :any_skip_relocation, big_sur:        "c294eccff528712de05bf1093be22936efe5743107d74d0a64137c2d4ece0254"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8e6d7e8c81de8169d368f1b24733789ae4206dbf92deac01199ff2f34a0c46e"
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
