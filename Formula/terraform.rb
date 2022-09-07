class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v1.2.9.tar.gz"
  sha256 "40aba75e2fcc3088a88b086a6038c8fb3b1dbe93ac769124c72ce1983558bec7"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/terraform/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38933804d03315826e5ada4fc1966299e796f864565dbd2abc638618f47b08e3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6c7d25b14bf83f5b194800307212b0b4e2bc56ec493c1c33f13618254ec421f3"
    sha256 cellar: :any_skip_relocation, monterey:       "b706c616ec77c065678f18fb3b4c3c1d9b5498c27f4e11c0db653e9893f1984d"
    sha256 cellar: :any_skip_relocation, big_sur:        "5374d9bf60ada3dc2c3b2d795ff757ec9f3b7ad6426a446d730ae8f4422936d3"
    sha256 cellar: :any_skip_relocation, catalina:       "39990d81d8a9d55a0b7768c522e01a7e3bcac40dbbdecc1d0fe5dd26e3aa2844"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a94262a410a8e1c47c6370028c867b9d595e479312ed99e970e98f4e50d3c0b"
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
