class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v1.5.2.tar.gz"
  sha256 "1fb4e2e583a65583a24a8af3699fd0a9cd762da71b2436d0b62e448fe89180e9"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/terraform/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cfe44675e962fc5188ca51de8a71321cd54d9da86fc2d1ef245eb8e9d3bb652a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cfe44675e962fc5188ca51de8a71321cd54d9da86fc2d1ef245eb8e9d3bb652a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cfe44675e962fc5188ca51de8a71321cd54d9da86fc2d1ef245eb8e9d3bb652a"
    sha256 cellar: :any_skip_relocation, ventura:        "147474dc46877700e3678b6e7c41e4136c02346efaab1155f0597358ae6c64c9"
    sha256 cellar: :any_skip_relocation, monterey:       "147474dc46877700e3678b6e7c41e4136c02346efaab1155f0597358ae6c64c9"
    sha256 cellar: :any_skip_relocation, big_sur:        "147474dc46877700e3678b6e7c41e4136c02346efaab1155f0597358ae6c64c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec6ce8db5bca1230d193ad3107643d0e929e2f05ea7c075a5d4710a2434a211a"
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
