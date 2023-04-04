class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v1.4.4.tar.gz"
  sha256 "ab9e6d743c0a00be8c6c1a2723f39191e3cbd14517acbc3e6ff2baa753865074"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/terraform/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b275c125ecc74f735d4772912df098cde497d7b37f40a79941d1242f51e3cfe6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b275c125ecc74f735d4772912df098cde497d7b37f40a79941d1242f51e3cfe6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b275c125ecc74f735d4772912df098cde497d7b37f40a79941d1242f51e3cfe6"
    sha256 cellar: :any_skip_relocation, ventura:        "a24244e9045ebc2f91e1496b4d894d953927658ee7ca6ac4e77ac66cd766a820"
    sha256 cellar: :any_skip_relocation, monterey:       "a24244e9045ebc2f91e1496b4d894d953927658ee7ca6ac4e77ac66cd766a820"
    sha256 cellar: :any_skip_relocation, big_sur:        "a24244e9045ebc2f91e1496b4d894d953927658ee7ca6ac4e77ac66cd766a820"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68ae13124ddc755456c58924623131338c223f67a7158c248de986de831f1100"
  end

  depends_on "go" => :build

  conflicts_with "tfenv", because: "tfenv symlinks terraform binaries"

  # Needs libraries at runtime:
  # /usr/lib/x86_64-linux-gnu/libstdc++.so.6: version `GLIBCXX_3.4.29' not found (required by node)
  fails_with gcc: "5"

  def install
    ldflags = %w[-s -w]
    if build.stable?
      ldflags += %W[
        -X github.com/hashicorp/terraform/version.Version=#{version}
        -X github.com/hashicorp/terraform/version.Prerelease=
      ]
    end

    system "go", "build", *std_go_args(ldflags: ldflags)
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

    assert_match(/^Terraform v#{Regexp.escape(version)}$/, shell_output("#{bin}/terraform version"))
  end
end
