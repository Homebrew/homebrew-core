class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v1.3.1.tar.gz"
  sha256 "215451421172f362706a57a41b4b91a07006879ee57d1624c63a4784609cd4b6"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/terraform/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a4dc27f89f7a0616e31ba2444cf528fdb162e313f8032d44f2a2fb2f645bb29"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "949cbb37ce0ffcd70256ee5b9b588ec4c216e7a8e14ee9d7dcee695792e83374"
    sha256 cellar: :any_skip_relocation, monterey:       "e362a15bbdf61b2004b39ffef6cc541da27ae8dbc89f0c5b6a9d9c7e2754d0e9"
    sha256 cellar: :any_skip_relocation, big_sur:        "bbce64b25225c8813f317dac5b3f7c2e3089675bd9765cc62d46af8f1205bc5b"
    sha256 cellar: :any_skip_relocation, catalina:       "1479006c6b129e5b74d75b950d216d401739a75d4186f2de0a834394f2985589"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "204d69cfa9f0e2242fc110ee1f6fba5e5d47f5c9af88f51c6989c421761d5af3"
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
