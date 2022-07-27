class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v1.2.6.tar.gz"
  sha256 "16cca15724e0bf76c24043050ec7339cde1963d5a3e1c8aa23a608e3b0371d8c"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/terraform/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a880296ef6971b7fcdab90955b8e66664fe9c8c38898071f7d18c99843cbe26c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "36e287e5db5040f15ee0ba3e6c25ab6f8dea450a4fa706d0e0dab207c4cc67e3"
    sha256 cellar: :any_skip_relocation, monterey:       "30afdfb7bf6bddeb74508a7c17a224de5c044fcb25ad5988f63e1ea399d69f99"
    sha256 cellar: :any_skip_relocation, big_sur:        "de2a9dccdf32ff17669498b4339ac9e2ea16e993cb0e13f15773d4d7183efcd9"
    sha256 cellar: :any_skip_relocation, catalina:       "5d1200a70bb97429dddbac37b39601c2d9c588ee7a7c533dfb04a1828986175e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef96095c394c2f474b925eba6c13b65dbbe5823e7d9c7c052ee492190bd692a8"
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
