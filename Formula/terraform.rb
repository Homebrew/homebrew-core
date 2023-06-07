class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v1.4.6.tar.gz"
  sha256 "6c3e538f8c2ebaf1d5ac1f929753c4fabddb8b3af638829212df494c569a8d02"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/terraform/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bd665df406311a275e5618f11c0d20035e12c2293aca093d544e331884f3f41b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd665df406311a275e5618f11c0d20035e12c2293aca093d544e331884f3f41b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bd665df406311a275e5618f11c0d20035e12c2293aca093d544e331884f3f41b"
    sha256 cellar: :any_skip_relocation, ventura:        "b10120c9205cab71c80f95e0dae6e2725b3a359125944653c0d8b51c314a7cc6"
    sha256 cellar: :any_skip_relocation, monterey:       "b10120c9205cab71c80f95e0dae6e2725b3a359125944653c0d8b51c314a7cc6"
    sha256 cellar: :any_skip_relocation, big_sur:        "b10120c9205cab71c80f95e0dae6e2725b3a359125944653c0d8b51c314a7cc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc1134117c0e19a6865965f397787084086ea1af1e5682d5ac20287d1b94a831"
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
