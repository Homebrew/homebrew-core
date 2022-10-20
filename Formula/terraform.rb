class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v1.3.2.tar.gz"
  sha256 "51c41c40bcd87b917046b786cf6d32d3b2b5f6c5fc4cb84121944efc9be54cc0"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/terraform/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95ce6ce52c67575858cfd9d65058cf31ff9de8503208c7e75887571f17c79cf5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "00073df2036218aa91fe1a2f8cade1cba92a0a5884854b4f7ae38d4d914070bc"
    sha256 cellar: :any_skip_relocation, monterey:       "fa84bcc3edf52c4ab2a395318483ec9fb185113164cf9b2cc3b81d2f93a4de65"
    sha256 cellar: :any_skip_relocation, big_sur:        "6bcfea009b70216f293f0d53d498ac9913cd041fe73d4bb835be32cc075eb9e8"
    sha256 cellar: :any_skip_relocation, catalina:       "670fd81ea25ffa96fbe9c16a24993d6e544057f9ef390ff124297d4c02c2f685"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7eaa48384d6f78ac4af63fdc37446ae10b6ba107ec87d982f230438a9dbf7b7f"
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
