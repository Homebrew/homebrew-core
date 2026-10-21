class Terratag < Formula
  desc "CLI to automate tagging for AWS, Azure & GCP resources in Terraform"
  homepage "https://www.terratag.io/"
  url "https://github.com/env0/terratag/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "3ffded4956af55a5a81e077c3e44eabcb76893cfba371df069fa296a2d07e606"
  license "MPL-2.0"
  head "https://github.com/env0/terratag.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3c321ce81960611f1c49428dbdace9866586adf5e01bb519e4fbbed71df68c5a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3c321ce81960611f1c49428dbdace9866586adf5e01bb519e4fbbed71df68c5a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3c321ce81960611f1c49428dbdace9866586adf5e01bb519e4fbbed71df68c5a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f70e71aa665255dc95dbe7a9dcb58fcdf1dc310cb75deccd30d707c1f98386a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "13c7e2e035f8c43e551b313da97e9189f4f50dec454880cb52a706d8f59f8587"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/terratag"
  end

  test do
    (testpath/"main.tf").write <<~HCL
      provider "aws" {
        region = "us-east-1"
      }

      resource "aws_instance" "example" {
        ami           = "ami-12345678"
        instance_type = "t2.micro"
      }
    HCL

    output = shell_output("#{bin}/terratag -dir #{testpath} " \
                          "-tags '{\"environment\":\"test\",\"owner\":\"brew\"}' -rename=false 2>&1", 1)

    assert_match "terraform init must run before running terratag", output
  end
end
