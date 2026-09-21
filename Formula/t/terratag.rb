class Terratag < Formula
  desc "CLI to automate tagging for AWS, Azure & GCP resources in Terraform"
  homepage "https://www.terratag.io/"
  url "https://github.com/env0/terratag/archive/refs/tags/v0.7.7.tar.gz"
  sha256 "b55d582f06647951003844c1c7e343ffe260f6fb34abeeb688178bdee1a0ba7b"
  license "MPL-2.0"
  head "https://github.com/env0/terratag.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1181a719c233429f71a4c9cbd316ba2e50ec0c8c85f677e61849285a29dfe408"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1181a719c233429f71a4c9cbd316ba2e50ec0c8c85f677e61849285a29dfe408"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1181a719c233429f71a4c9cbd316ba2e50ec0c8c85f677e61849285a29dfe408"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "1181a719c233429f71a4c9cbd316ba2e50ec0c8c85f677e61849285a29dfe408"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8a1322f0aabb0507f5f8737812ebd038e8631b2ea4fa8a43b14cf16d20878094"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "231afb499d1e63a02c585638597f98395a14a68f9cb3252d6d2416695e12215f"
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
