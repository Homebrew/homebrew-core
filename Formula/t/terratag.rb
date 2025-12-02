class Terratag < Formula
  desc "CLI to automate tagging for AWS, Azure & GCP resources in Terraform"
  homepage "https://www.terratag.io/"
  url "https://github.com/env0/terratag/archive/refs/tags/v0.7.4.tar.gz"
  sha256 "01d40560d92ddd2cfce53d3bb71008a23de804f2a8b64006e9a0bd10b489c718"
  license "MPL-2.0"
  head "https://github.com/env0/terratag.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9eab14fba8d15d3d0a5a61c9a2c95f593ad99d795790b8027e09728798f55b47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9eab14fba8d15d3d0a5a61c9a2c95f593ad99d795790b8027e09728798f55b47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9eab14fba8d15d3d0a5a61c9a2c95f593ad99d795790b8027e09728798f55b47"
    sha256 cellar: :any_skip_relocation, sonoma:        "00fa0d836f1c3c7a8e353f8c7da7b98f80307af64aeaf0e5c5550d73b0779cf3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3ce02ca569409c64afb8035d2e36fadb96b2d8fb34dc2ab6a1d1695b0686ce3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01645ab89c7a380f09bb1a76aaab15872e08484663c970a87fa2208510e02f7a"
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

    system bin/"terratag", "-dir", testpath.to_s, "-tags", '{"environment":"test","owner":"brew"}',
                           "-rename=false"

    output = shell_output("#{bin}/terratag -dir #{testpath} " \
                          "-tags '{\"environment\":\"test\",\"owner\":\"brew\"}' -rename=false 2>&1")

    assert_match "terraform init must run before running terratag", output
  end
end
