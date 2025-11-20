class Terratag < Formula
  desc "CLI to automate tagging for AWS, Azure & GCP resources in Terraform"
  homepage "https://www.terratag.io/"
  url "https://github.com/env0/terratag/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "ae27b37043126bd18271e157018fc49b826fdbe8346d2074dddc83bf771c8e6b"
  license "MPL-2.0"
  head "https://github.com/env0/terratag.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0eaf6a4bfb673e20ce191c14ca054364cb8808830360c21666d1a09e8845d94d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0eaf6a4bfb673e20ce191c14ca054364cb8808830360c21666d1a09e8845d94d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0eaf6a4bfb673e20ce191c14ca054364cb8808830360c21666d1a09e8845d94d"
    sha256 cellar: :any_skip_relocation, sonoma:        "5408650be83085a17f5a9eba64c9dfea56ece0bc7d0380c68ace19e690c5dfac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e558591f774d3476b577d99c5cc7f1c836f7722ff204e1881103dded4e251668"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7458454f1f48018fc049b9a3ace224d76b6f264924fab5ba8759e7eb0be31d2"
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
