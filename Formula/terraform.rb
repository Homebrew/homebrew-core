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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2cb6b6950ef7d6dad1679305f6614e38403014430847a34f58eafe2274cfaf2a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "29cae17432edddc3e58b8f0fe6fd138d37e6d569fe7d32484e088f1bc25da2ee"
    sha256 cellar: :any_skip_relocation, monterey:       "4bd4be5e73d94bc7ef42fc1eb83134bdc93dbabcff7ea53cc3f7976322fa75f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "6fb97d8183d911eafb3db03d4f4d938f662b7058d58d063bce28a70e6bc3977e"
    sha256 cellar: :any_skip_relocation, catalina:       "e444e34f62507331727b8144a84272da8ed353c5e6bd59fdd2eb6280cbaa75ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d25dbff985d5aadaec349499f30b6a3fa3ec79a41df363846d48f49006c5c6ee"
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
