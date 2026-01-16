class Terratag < Formula
  desc "CLI to automate tagging for AWS, Azure & GCP resources in Terraform"
  homepage "https://www.terratag.io/"
  url "https://github.com/env0/terratag/archive/refs/tags/v0.7.6.tar.gz"
  sha256 "d9f1a1a2ef6eb28accd114130e09a26644cf079827c5050dc6b1969ad29b9cbf"
  license "MPL-2.0"
  head "https://github.com/env0/terratag.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ec3de53b4f5ff7ad700ae77ac76986e7d56834296725e768766111bd1e962627"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec3de53b4f5ff7ad700ae77ac76986e7d56834296725e768766111bd1e962627"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec3de53b4f5ff7ad700ae77ac76986e7d56834296725e768766111bd1e962627"
    sha256 cellar: :any_skip_relocation, sonoma:        "7fb26745918e415535ac96dd21655cb3dca676cdb458234483b042e377ed601b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed92750d7fc30bc31568d9e5624debe9fa8e66d971d39d7a39ab0575990b81c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1d2ddfd257b6fcb1b27d496d5b34b9842a733e56b4343bb3735384615b6a260"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/terratag"
  end

  test do
    (testpath/"main.tf").write <<~EOS
      provider "aws" {
        region = "us-east-1"
      }

      resource "aws_instance" "example" {
        ami           = "ami-12345678"
        instance_type = "t2.micro"
      }
    EOS

    output = shell_output("#{bin}/terratag -dir #{testpath} " \
                          "-tags '{\"environment\":\"test\",\"owner\":\"brew\"}' -rename=false 2>&1", 1)

    assert_match "terraform init must run before running terratag", output
  end
end
