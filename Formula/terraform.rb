class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v1.1.2.tar.gz"
  sha256 "fdb86ce8eeb5ccba851d9e806449653b2c2f0a14b4d1e3f4c82fd72ab032ded9"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/terraform/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cff732fb2297ddefc182bdd5111524ba6603e38aa8954cd7ccddb3666dcde7bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6c296ef85aac6d4e4f3157092417e4c0657de8cff2cd601bf2faf93a1ad83322"
    sha256 cellar: :any_skip_relocation, monterey:       "bcec7b0d20aad0d9123236b23e5f22f30e496ef69d5d6c83ad2da709ff2bfe42"
    sha256 cellar: :any_skip_relocation, big_sur:        "c030e673204c4c9874c0e03e28a5942c616301096b5d8ef70c222be69aace331"
    sha256 cellar: :any_skip_relocation, catalina:       "a0091a6944057de31361011e44cb1ee78828b05cebc11a43cd2d335e3a48c798"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e005226d4a2109f83307dc685f9045732b8288adf3499996797e7109c9c97ae6"
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
