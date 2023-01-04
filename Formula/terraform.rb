class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v1.3.7.tar.gz"
  sha256 "36bc7319bf97965144a38c2670f458752f7cb8e7fd783c216b4a24bebee2a8c4"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/terraform/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fcc194022331b75839fbb02a96cf1eafe53a8df582d3b40a2d9da186399ce2da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ff347c3232c96410d195ec85b34cfb12295138d6cb64a3fea6c7041387896a7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c2d4685cff0e9b0d19f1f8650f50c72a40c5bb60914da15967204f7a87b18710"
    sha256 cellar: :any_skip_relocation, ventura:        "dad3b9cce25f6ae0d5ddb06029fc266af2d337013828fda6b5fb6c2bcf3f5d14"
    sha256 cellar: :any_skip_relocation, monterey:       "3688837e982bed420f0e5903e5c38a0b31360a6cdec5e25df6aae415d94c9786"
    sha256 cellar: :any_skip_relocation, big_sur:        "e5c930110fc4d1e6af910e559eb597fa05bc5c5969e82240f4bd8f140b890fa0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aad443d8d1e5b11372c5ef2759e6164992ffbf9a67c92c3cc1d95ba1115dcdfa"
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
