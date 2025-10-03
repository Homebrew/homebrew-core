class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  # NOTE: Do not bump to v1.6.0+ as license changed to BUSL-1.1
  # https://github.com/hashicorp/terraform/pull/33661
  # https://github.com/hashicorp/terraform/pull/33697
  url "https://github.com/hashicorp/terraform/archive/refs/tags/v1.5.7.tar.gz"
  sha256 "6742fc87cba5e064455393cda12f0e0241c85a7cb2a3558d13289380bb5f26f5"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "87e8faf4dc4090ff8259a2cc258ac20518c154989af694475a3105d5ad57d664"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "82a9dcb1351fa533ea106fe0222678c89814a42ce4939d17c01178f4dbff4713"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b9f647f7ab0dc2c8878c6f4ab51bcd412197bc02e30389b15cc37de2b0dfaf8b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b14e9ffc5a5d154e5d6b58b94c18372c2f69c5ce1fd5735b351c1a1bac0187f"
    sha256 cellar: :any_skip_relocation, sonoma:         "9ce38d4ffe85f9530ba5911299d190f0a119610c4fd9fc6b30f57871647b61cb"
    sha256 cellar: :any_skip_relocation, ventura:        "f68fee2494570a785d854056484c6853421e592a7e58489bfdc692ef87913412"
    sha256 cellar: :any_skip_relocation, monterey:       "b8cef4d46451e2780754cdf5c5510b8ed458025668a03beb1dd69c23b61396ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "390afc2492fa4ea2fc7dce55efa25b9ae09e060639e1dc3d9c160718893881b3"
  end

  # https://www.hashicorp.com/blog/hashicorp-adopts-business-source-license
  deprecate! date: "2024-04-04", because: "changed its license to BUSL on the next release"
  disable! date: "2025-04-12", because: "changed its license to BUSL on the next release"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  def caveats
    <<~EOS
      We will not accept any new Terraform releases in homebrew/core (with the BUSL license).
      The next release changed to a non-open-source license:
      https://www.hashicorp.com/blog/hashicorp-adopts-business-source-license
      See our documentation for acceptable licences:
        https://docs.brew.sh/License-Guidelines
    EOS
  end

  test do
    minimal = testpath/"minimal.tf"
    minimal.write <<~HCL
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
    HCL
    system bin/"terraform", "init"
    system bin/"terraform", "graph"
  end
end
