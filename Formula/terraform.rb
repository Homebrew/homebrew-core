class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v1.2.5.tar.gz"
  sha256 "512669ea88e3e70ef83604d90d0553c1f5b239965bb1b8cbf8f6e8b1df153d15"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/terraform/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "304928359f2e899ace5b51fde3e658aa738875005a105f1110918397643348be"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a80454bb48cc969b3f5d1be7d9888187ce4b6a1178e0778b051c9156eaf964f8"
    sha256 cellar: :any_skip_relocation, monterey:       "9aedba4f772a720966104bfed56419d8f1449e61bea6e084ae937d4361398ca5"
    sha256 cellar: :any_skip_relocation, big_sur:        "253adfffdc2017adbdf5449d0f7a865152bcb6d8587e254c5d03091ea742202a"
    sha256 cellar: :any_skip_relocation, catalina:       "ba5e1d87d5fcf97aa31fdb74a87363c060a940dabfac07e8465f1363bb38d341"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d53025ff6600751d3e1d4d20caa6d54d45a209a791660a0c6d56747ddfe5dce"
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
