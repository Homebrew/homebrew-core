class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  # NOTE: Do not bump to v1.6.0+ as license changed to BUSL-1.1
  # https://github.com/hashicorp/terraform/pull/33661
  # https://github.com/hashicorp/terraform/pull/33697
  url "https://github.com/hashicorp/terraform/archive/v1.5.7.tar.gz"
  sha256 "6742fc87cba5e064455393cda12f0e0241c85a7cb2a3558d13289380bb5f26f5"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform.git", branch: "main"

  # TODO: Remove this if/when the formula is deprecated.
  livecheck do
    skip "Formula will not be updated due to BUSL license change"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f43afa7c6970e1bc768f739829ee589e88fd2b9275f867c5d0be60369ce0772e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c6612f5b1c9921da6fa968698a1d657edaff64fbf62d53ae06850cc6897d8d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "021a01f961c82496855d015abe60a30c6917bd01140fbe674ca31ed7e8e878df"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "df60e68a8a1c88147221063845f7ed640414049b9b3ff84ea1e2f180d5dc0038"
    sha256 cellar: :any_skip_relocation, sonoma:         "ab2ee13ac9d5503f45838166c3d108b909d0420df9119b1fd5ea7c2fe5666342"
    sha256 cellar: :any_skip_relocation, ventura:        "c5ff87413adc57a4d70c629edac3c5f2c39ddec69771c18402f803023249abc3"
    sha256 cellar: :any_skip_relocation, monterey:       "19dd31b33a7e2bdc5fac6c23b1fc62f66a9cf9e00ac724f1b01c43e740c65aa4"
    sha256 cellar: :any_skip_relocation, big_sur:        "e85d465cbe14dfc77e0b7bdad6d986705822c631d2bdc087e6f9a795a03f0353"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67fee97d6db4e6fb1d53a3c0f5bb092b11cd41966a36078a5d846272d59bb8ea"
  end

  depends_on "go" => :build

  conflicts_with "tfenv", because: "tfenv symlinks terraform binaries"

  # Needs libraries at runtime:
  # /usr/lib/x86_64-linux-gnu/libstdc++.so.6: version `GLIBCXX_3.4.29' not found (required by node)
  fails_with gcc: "5"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
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
