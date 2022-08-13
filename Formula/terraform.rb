class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v1.2.7.tar.gz"
  sha256 "8d5695071ca0e59e7b52a717734a0f65f7853183b56df776a165fa0d56f417d1"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/terraform/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4a34bb99d296379a2f308caebe2468ab6bc4b2151805d99a10f22edf7e8beb8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "20e9b22212cab236757c45849495426cb179ef493ce0438b4012d93591478289"
    sha256 cellar: :any_skip_relocation, monterey:       "6b654a80b470926b6fc956c0aa7d5ba64402dddb9119f580dbc436b0a9edb827"
    sha256 cellar: :any_skip_relocation, big_sur:        "3035004a02cb5433e47bc510fdae4a0408e31bad51d433378993660980ab1c0d"
    sha256 cellar: :any_skip_relocation, catalina:       "012f4eaab2ff82f5865f507f3eaf542f918aff4e1584dda92e564eb07022991a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af710640ce8defb75e3080dffe63e81c5c0f59f1bb9ec95947e39789b751e31b"
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
