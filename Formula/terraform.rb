class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v1.3.5.tar.gz"
  sha256 "6c44d7b30b31c68333688a794646077842aea94fe6073368824c47d57c22862e"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/terraform/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "56768bc60e7bc8300587d80e47f457e1897c292fa2f634404d69d2c8e307b40e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c433a55671fe94926cbd3f72f08a2a7815124bcee534aab3beb76e258c2b9bd7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "290f992fd4ede7b09bab90186da6974dfc526ca025180c4856a2db4cdcbb6c4b"
    sha256 cellar: :any_skip_relocation, monterey:       "d908cc879a56a23831a57e5e93f05bf8ade367d18448815b328154cbb07b364c"
    sha256 cellar: :any_skip_relocation, big_sur:        "a7cab10bee32c1c7153a9d11b74f48dd1186c07bae9a1a490f2a9dce1d3f4268"
    sha256 cellar: :any_skip_relocation, catalina:       "cec9a6abc72ee2a7bff108a71814d7bc01caa9a39309650a3aa2e08b266af8a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4443716deb077a71796124be168f2586cba2e6f069940c491537c17080e9bae5"
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
