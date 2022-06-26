class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v1.2.3.tar.gz"
  sha256 "0bc726b85e0ef7325f9cc525f6e57cba46ed24e23f7d7d3d0ed3df91811a4ac6"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/terraform/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95d66766187bcf0a1fb0f11739804bbd3d85820092467605d4598c8b716189fa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dec852146c739321b814a9764677b32efb2e6c3d2c743f67b6bb5fa4589d5823"
    sha256 cellar: :any_skip_relocation, monterey:       "83e062fc065d683eac58708bcb4931691b9e4864be3099989d7b9b4525d7c591"
    sha256 cellar: :any_skip_relocation, big_sur:        "34d778a84ea3eaff07e38f1a965d8cf851027cbd0b4f2f2600b5b611f3d923d9"
    sha256 cellar: :any_skip_relocation, catalina:       "92b856600b8c7dac1835892ef01f1a0317c16c78114898cbb3153e62c18182bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1266037a36d1dc7628211c08075db8a38dba31b30b3c448720e8ed4fe2ea3654"
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
