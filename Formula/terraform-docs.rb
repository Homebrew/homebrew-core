class TerraformDocs < Formula
  desc "Tool to generate documentation from Terraform modules"
  homepage "https://github.com/terraform-docs/terraform-docs"
  url "https://github.com/terraform-docs/terraform-docs/archive/v0.14.1.tar.gz"
  sha256 "6c3157cb7eaac2e62b32556ab9cd5f83e58c2934aa3eb7c1e61c00c7c5b1e186"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a7a1a54abd1ff26f28e1c23675580bbefa727e40a992c60a45dc42f4804cce2b"
    sha256 cellar: :any_skip_relocation, big_sur:       "c278017d514b3b46ad45ee63c0823ea7ef43fc41091b361302618ab75c0b9c07"
    sha256 cellar: :any_skip_relocation, catalina:      "68f0e4331dc354e8089f9bc580692c1125ec725aa61afb669d95c12929ecaff7"
    sha256 cellar: :any_skip_relocation, mojave:        "c7f0532f8b2f0fbe5d80ac61aacbe1c760c4d4b0e206f198363e0ad9192459a7"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    cpu = Hardware::CPU.arm? ? "arm64" : "amd64"
    os = "darwin"
    on_linux do
      os = "linux"
    end
    bin.install "bin/#{os}-#{cpu}/terraform-docs"
    prefix.install_metafiles
  end

  test do
    (testpath/"main.tf").write <<~EOS
      /**
       * Module usage:
       *
       *      module "foo" {
       *        source = "github.com/foo/baz"
       *        subnet_ids = "${join(",", subnet.*.id)}"
       *      }
       */

      variable "subnet_ids" {
        description = "a comma-separated list of subnet IDs"
      }

      variable "security_group_ids" {
        default = "sg-a, sg-b"
      }

      variable "amis" {
        default = {
          "us-east-1" = "ami-8f7687e2"
          "us-west-1" = "ami-bb473cdb"
          "us-west-2" = "ami-84b44de4"
          "eu-west-1" = "ami-4e6ffe3d"
          "eu-central-1" = "ami-b0cc23df"
          "ap-northeast-1" = "ami-095dbf68"
          "ap-southeast-1" = "ami-cf03d2ac"
          "ap-southeast-2" = "ami-697a540a"
        }
      }

      // The VPC ID.
      output "vpc_id" {
        value = "vpc-5c1f55fd"
      }
    EOS
    system "#{bin}/terraform-docs", "json", testpath
  end
end
