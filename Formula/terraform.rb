class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v1.1.3.tar.gz"
  sha256 "7539f1bcc94477cce5c153ed205a7122cc4c8f389563999f7e870527978c024c"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/terraform/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1fd9bc5651b795890d69fd54ef11de20de4cafbd764b5d9672598108ad479b46"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "15f1573261c8502b2be5882aa0b2bacd2cac27ea06c622e406466044018c3377"
    sha256 cellar: :any_skip_relocation, monterey:       "da0a4ce60489f2d58edbab97443a8ef594d9781a13bb08da6d22c6cb7832a5a5"
    sha256 cellar: :any_skip_relocation, big_sur:        "13cf6394ce6b88aab533cb9e0a28ee261fc849761e07f81accd9f8217cd1f2ad"
    sha256 cellar: :any_skip_relocation, catalina:       "c4f34b37cc128d936b9d08c1a8a217bc372ec07736ffa817f1e9fc02e4650b12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6dc578410c3c229cabb61003db1f5e0f0473f74461f482d8498c52597af9925c"
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
