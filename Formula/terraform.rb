class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v1.2.0.tar.gz"
  sha256 "c56b38dc8d32a1a26c80318ca40f0ad0cd62e1325327bcdede2cab5f655a757e"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/terraform/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8eb855b77c878285f24ed5011440831b91dea7017ad3c5850ef14476dd48cda2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9020350339c319224abee115bc4db4c430a67097554a1fb42199e367b36636b7"
    sha256 cellar: :any_skip_relocation, monterey:       "6d350b95a7fdb19559bba4e1d09a880c47ea5d7f3bdc5359ed277557c7555a23"
    sha256 cellar: :any_skip_relocation, big_sur:        "3b12ec27f61e0ae0bc22b579cf1fab5ca6bc515f84333e9a96982cbf6bce9b0f"
    sha256 cellar: :any_skip_relocation, catalina:       "162d81020985a4e7008c2f9d7502d9dd38f686149d4ecf62c229f58947910ae8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7184c339c69cdb9360652bb5a31817d476a512b83cc7b0aead784fdd61c213ca"
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
