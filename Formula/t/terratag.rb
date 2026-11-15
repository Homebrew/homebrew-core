class Terratag < Formula
  desc "CLI to automate tagging for AWS, Azure & GCP resources in Terraform"
  homepage "https://www.terratag.io/"
  url "https://github.com/env0/terratag/archive/refs/tags/v0.8.3.tar.gz"
  sha256 "74a8f4ca1553cbdd2f9c84dde2312ec0debbbd2093486234fa7a7b107ac8c863"
  license "MPL-2.0"
  head "https://github.com/env0/terratag.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e51749161d7c5a4ff1c962a64843facbd584dfea55403bc736f25f59d5b1a09f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e51749161d7c5a4ff1c962a64843facbd584dfea55403bc736f25f59d5b1a09f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e51749161d7c5a4ff1c962a64843facbd584dfea55403bc736f25f59d5b1a09f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1415fde11847e81f564f6f351cf087769c51e3ed2cbdf7b178b184885ca66032"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "53b3048bb6bedef29c9c5008d117ca617368b2eb3fc5dc615b1428222d556073"
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
