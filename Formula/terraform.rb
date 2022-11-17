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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5558fcb735cc18ac3022c104bf4fac0397707cc99cfc0b279ecc69c3d31e5cea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "007f2cf0531616dd35bb717eeb453e76cce61e25cb8efbc78329b01ba1576f43"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "727391d7b16a103ecfc7f1f954058b954c5617c293ee74f75e75dd1793c960a0"
    sha256 cellar: :any_skip_relocation, ventura:        "81e4c6ef3e3e910784147a7f411306b4d60754892768ce3cd3f8f5e691162730"
    sha256 cellar: :any_skip_relocation, monterey:       "0decc7b372466e9643f4b0e21519c043d0018fbd309585274d4e54ef8f4082b2"
    sha256 cellar: :any_skip_relocation, big_sur:        "f12b0f68589802c23535c80b535e4575c50d24b6c9e90bb927ee261aa2adb0f9"
    sha256 cellar: :any_skip_relocation, catalina:       "c980d46c29f6683cae67b8bf71012a73f4e10375e8461a0e504fdff262e37798"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f16ba9bbac42711c3f706be33a578567ada53a7b61ae77e0b2b9e6dc5291b0d0"
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
