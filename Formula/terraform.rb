class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v1.1.7.tar.gz"
  sha256 "7651b69a2196de4393195cef4a03171c83aa50581f1019bca3f17cf05db5335b"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/terraform/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41f49ead29b3a20299cb02789a7f359ff88018dc66e89f92fae1b3eae8ad1289"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ba545d26a6d30114cc8ab15070088bdf9cae10c60f61b1c0c35c233bacc28f36"
    sha256 cellar: :any_skip_relocation, monterey:       "0e98c8fe2e6757f717ef3b02bd2b90a997046711ca64a1fee1b770f014820cb3"
    sha256 cellar: :any_skip_relocation, big_sur:        "f00a046d6a00109dd7020bf8fb3072b860db8bb40df377ae64b7c6992a1fe4ab"
    sha256 cellar: :any_skip_relocation, catalina:       "302112eecd79e8c5f55e2bf8a37bc071a2c723548c7efa9e1d9d945948c3c032"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a53e2871ae768c20b40b4c123ec94bec9fffba07133f3a3d00d1646e1e34eba"
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
